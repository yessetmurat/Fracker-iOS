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

    init(view: AuthViewInput, commonStore: CommonStore, networkService: NetworkService) {
        self.view = view
        self.commonStore = commonStore
        self.networkService = networkService
    }
}

extension AuthInteractor: AuthInteractorInput {

    func signInWithApple(authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return view.showAlert(message: "Unable to get credentials")
        }

        let data = AppleSignInData(
            appleIdentityToken: credential.user,
            firstName: credential.fullName?.givenName,
            lastName: credential.fullName?.familyName
        )
        let networkContext = AppleSignInNetworkContext(data: data)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self, !interactor.handleFailure(response: response, view: interactor.view) else {
                return
            }

            guard let token = response.json?["token"] as? String else {
                return interactor.show(networkError: .dataLoad, view: interactor.view)
            }

            interactor.commonStore.accessToken = token
            KeyValueStore().set(value: token, for: .token)

            interactor.view.dismiss(animated: true)
        }
    }
}
