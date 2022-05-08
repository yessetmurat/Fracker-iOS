//
//  AuthRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import NetworkKit
import BaseKit

class AuthRouter {

    private unowned let commonStore: CommonStore
    private unowned let profileStore: ProfileStore
    private unowned let parentRouter: ParentRouterInput
    private weak var view: AuthViewInput?

    init(commonStore: CommonStore, profileStore: ProfileStore, parentRouter: ParentRouterInput) {
        self.commonStore = commonStore
        self.profileStore = profileStore
        self.parentRouter = parentRouter
    }

    func compose() -> AuthViewInput {
        let viewController = AuthViewController()
        view = viewController

        let networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
        let categoriesService = CategoriesWorker(commonStore: commonStore)
        let recordsService = RecordsWorker(commonStore: commonStore)
        let interactor = AuthInteractor(
            view: viewController,
            commonStore: commonStore,
            profileStore: profileStore,
            networkService: networkService,
            categoriesService: categoriesService,
            recordsService: recordsService
        )
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension AuthRouter: AuthRouterInput {

    func reloadParentData() {
        parentRouter.reloadData()
    }
}
