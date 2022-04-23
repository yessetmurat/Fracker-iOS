//
//  AuthInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

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

    func signIn(email: String, password: String) {
        guard email.matches(Constants.emailRegex) else {
            return view.showAlert(title: "Attention!", message: "Enter correct email address")
        }

        view.set(isLoading: true)

        let networkContext = AuthNetworkContext(authType: .signIn, email: email, password: password)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self else { return }
            interactor.view.set(isLoading: false)

            if !interactor.handleFailure(response: response, view: interactor.view) {
                guard let token = response.json?["token"] as? String else {
                    return interactor.show(networkError: .dataLoad, view: interactor.view)
                }

                interactor.commonStore.accessToken = token
                KeyValueStore().set(value: token, for: .token)

                interactor.view.dismiss(animated: true)
            }
        }
    }

    func signUp(email: String, password: String, confirmPassword: String) {
        guard email.matches(Constants.emailRegex) else {
            return view.showAlert(title: "Attention!", message: "Enter correct email address")
        }

        guard password == confirmPassword else {
            return view.showAlert(title: "Attention!", message: "Passwords must match")
        }

        view.set(isLoading: true)

        let networkContext = AuthNetworkContext(authType: .signUp, email: email, password: password)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self else { return }
            interactor.view.set(isLoading: false)

            if !interactor.handleFailure(response: response, view: interactor.view) {
                interactor.view.configureSignIn()
            }
        }
    }
}
