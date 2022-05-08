//
//  RecordRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import NetworkKit
import BaseKit

class RecordRouter {

    private unowned let commonStore: CommonStore
    private let profileStore: ProfileStore
    private weak var view: RecordViewInput?

    init(commonStore: CommonStore, profileStore: ProfileStore) {
        self.commonStore = commonStore
        self.profileStore = profileStore
    }

    func compose() -> RecordViewInput {
        let viewController = RecordViewController()
        view = viewController

        let interactor = RecordInteractor(view: viewController, commonStore: commonStore)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension RecordRouter: ParentRouterInput {

    func reloadData() {
        view?.pass(isLoading: true)
        view?.reloadCategories()
    }
}

extension RecordRouter: RecordRouterInput {

    func presentAuthPage() {
        let router = AuthRouter(commonStore: commonStore, profileStore: profileStore, parentRouter: self)
        let viewController = router.compose()

        view?.presentBottomDrawerViewController(with: viewController)
    }

    func presentProfilePage() {
        let router = ProfileRouter(commonStore: commonStore, profileStore: profileStore)
        let viewController = router.compose()

        view?.presentBottomDrawerViewController(with: viewController)
    }

    func routeToAnalyticsPage() {
        let router = AnalyticsRouter(commonStore: commonStore)
        let viewController = router.compose()

        view?.push(viewController)
    }
}
