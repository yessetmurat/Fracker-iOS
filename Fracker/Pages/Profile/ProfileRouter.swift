//
//  ProfileRouter.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

class ProfileRouter {

    private unowned let commonStore: CommonStore
    private weak var view: ProfileViewInput?

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
    }

    func compose() -> ProfileViewInput {
        let viewController = ProfileViewController()
        view = viewController

        let interactor = ProfileInteractor(view: viewController)
        viewController.interactor = interactor
        viewController.router = self

        return viewController
    }
}

extension ProfileRouter: ProfileRouterInput {

}
