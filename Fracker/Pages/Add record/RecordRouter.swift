//
//  RecordRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Network11

class RecordRouter {

    private unowned let commonStore: CommonStore
    private weak var view: RecordViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func compose() -> RecordViewInput {
        let viewController = RecordViewController()
        view = viewController

        let categoriesService = CategoriesWorker(commonStore: commonStore)
        let interactor = RecordInteractor(view: viewController, categoriesService: categoriesService)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension RecordRouter: RecordRouterInput {

    func presentAuthPage() {
        let router = AuthRouter(commonStore: commonStore)
        let viewController = router.compose()

        view?.present(viewController, animated: true)
    }
}
