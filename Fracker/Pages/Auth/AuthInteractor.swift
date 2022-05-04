//
//  AuthInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import AuthenticationServices
import Network11

class AuthInteractor {

    private unowned let view: AuthViewInput
    private unowned let commonStore: CommonStore
    private let networkService: NetworkService
    private let networkManager = NetworkManager()

    init(view: AuthViewInput, commonStore: CommonStore, networkService: NetworkService) {
        self.view = view
        self.commonStore = commonStore
        self.networkService = networkService
    }
}

extension AuthInteractor {

    private func batchCreate(categories: [Category]) -> ManageableNetworkRequest? {
        let networkContext = BatchCreateCategoryNetworkContext(categories: categories)
        let request = networkService.buildRequest(from: networkContext) { _ in }
        return request as? ManageableNetworkRequest
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

        let data = AppleSignInData(
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
//                interactor.saveLocalDataToRemoteIfNeeded()
            }
        }
    }
}
