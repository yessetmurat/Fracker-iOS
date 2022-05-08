//
//  InitialRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import BaseKit
import NetworkKit

class InitialRouter {

    private unowned let commonStore: CommonStore
    private unowned let window: UIWindow
    private let profileStore: ProfileStore
    private weak var view: InitialViewInput?

    init(commonStore: CommonStore, window: UIWindow) {
        self.commonStore = commonStore
        self.window = window
        profileStore = ProfileStore()
    }

    func compose() -> InitialViewInput {
        let viewController = InitialViewController()
        view = viewController

        let networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
        let interactor = InitialInteractor(
            view: viewController,
            commonStore: commonStore,
            profileStore: profileStore,
            networkService: networkService
        )
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension InitialRouter: InitialRouterInput {

    func routeToRecordPage() {
        guard let initialView = window.rootViewController?.view else {
            fatalError("window.rootViewController?.view is nil")
        }

        let router = RecordRouter(commonStore: commonStore, profileStore: profileStore)
        let viewController = router.compose()
        let navigationController = BaseNavigationController(rootViewController: viewController)

        window.rootViewController = navigationController

        UIView.transition(
            with: window,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: { initialView.removeFromSuperview() }
        )
    }
}
