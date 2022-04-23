//
//  AuthRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Network11

class AuthRouter {

    private unowned let commonStore: CommonStore
    private weak var view: AuthViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func compose() -> AuthViewInput {
        let viewController = AuthViewController()
        view = viewController

        let networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
        let interactor = AuthInteractor(view: viewController, commonStore: commonStore, networkService: networkService)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension AuthRouter: AuthRouterInput {

}
