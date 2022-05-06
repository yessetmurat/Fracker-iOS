//
//  AnalyticsRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

class AnalyticsRouter {

    private unowned let commonStore: CommonStore
    private weak var view: AnalyticsViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func compose() -> AnalyticsViewInput {
        let viewController = AnalyticsViewController(style: .grouped)
        view = viewController

        let interactor = AnalyticsInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension AnalyticsRouter: AnalyticsRouterInput {

}
