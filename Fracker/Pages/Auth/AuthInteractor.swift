//
//  AuthInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import AuthenticationServices
import BaseKit
import NetworkKit
import GoogleSignIn

class AuthInteractor {

    private unowned let view: AuthViewInput
    private unowned let commonStore: CommonStore
    private let networkService: NetworkService
    private let networkManager = NetworkManager()
    private let procedureCallManager = ProcedureCallManager()
    private let categoriesService: CategoriesService
    private let recordsService: RecordsService

    init(view: AuthViewInput, commonStore: CommonStore, networkService: NetworkService) {
        self.view = view
        self.commonStore = commonStore
        self.networkService = networkService

        categoriesService = CategoriesWorker(commonStore: commonStore)
        recordsService = RecordsWorker(commonStore: commonStore)
    }

    private func executeWithDelay(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: completion)
    }

    private func syncronize() {
        let categoriesItem = ProcedureCallItem { [weak self] completion in
            guard let interactor = self else { return }

            interactor.view.set(statusText: "Syncing categories...")
            interactor.executeWithDelay { [weak interactor] in
                interactor?.categoriesService.syncronize(completion: completion)
            }
        }

        let recordsItem = ProcedureCallItem { [weak self] completion in
            guard let interactor = self else { return }

            interactor.view.set(statusText: "Syncing records...")
            interactor.executeWithDelay { [weak interactor] in
                interactor?.recordsService.syncronize(completion: completion)
            }
        }

        procedureCallManager.items.removeAll()
        procedureCallManager.items = [categoriesItem, recordsItem]
        procedureCallManager.perform(inSequence: true) { [weak self] in
            guard let interactor = self else { return }

            interactor.view.set(statusText: "Done!")
            interactor.executeWithDelay { [weak interactor] in interactor?.view.dismissDrawer(completion: nil) }
        }
    }
}

extension AuthInteractor: AuthInteractorInput {

    func signInWithApple(authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let identityTokenString = String(data: identityToken, encoding: .utf8) else {
            return view.showAlert(message: "Unable to get credentials")
        }

        view.startLoading()
        view.set(statusText: "Signing in...")

        let data = SignInData(
            idToken: identityTokenString,
            firstName: credential.fullName?.givenName,
            lastName: credential.fullName?.familyName
        )
        let networkContext = AppleSignInNetworkContext(data: data)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self else { return }

            if !interactor.handleFailure(response: response, view: interactor.view) {
                guard let token = response.json?["token"] as? String else {
                    return interactor.show(networkError: .dataLoad, view: interactor.view)
                }

                interactor.commonStore.accessToken = token
                KeyValueStore().set(value: token, for: .token)
                interactor.syncronize()
            }
        }
    }

    func signInWithGoogle() {
        view.startLoading()
        view.set(statusText: "Signing in...")

        let configuration = GIDConfiguration(clientID: Constants.googleClientId)
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: view) { [weak self] user, error in
            guard let interactor = self else { return }
            guard error == nil, let idToken = user?.authentication.idToken else {
                return interactor.show(networkError: .dataLoad, view: interactor.view)
            }

            let data = SignInData(
                idToken: idToken,
                firstName: user?.profile?.givenName,
                lastName: user?.profile?.familyName
            )

            let networkContext = GoogleSignInNetworkContext(data: data)
            interactor.networkService.performRequest(using: networkContext) { [weak interactor] response in
                guard let interactor = interactor else { return }

                if !interactor.handleFailure(response: response, view: interactor.view) {
                    guard let token = response.json?["token"] as? String else {
                        return interactor.show(networkError: .dataLoad, view: interactor.view)
                    }

                    interactor.commonStore.accessToken = token
                    KeyValueStore().set(value: token, for: .token)
                    interactor.syncronize()
                }
            }
        }
    }
}
