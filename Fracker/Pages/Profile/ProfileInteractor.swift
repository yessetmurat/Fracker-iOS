//
//  ProfileInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import BaseKit

class ProfileInteractor {

    private unowned let view: ProfileViewInput
    private unowned let commonStore: CommonStore
    private unowned let profileStore: ProfileStore
    private var sections: [ProfileSection] = []

    init(view: ProfileViewInput, commonStore: CommonStore, profileStore: ProfileStore) {
        self.view = view
        self.commonStore = commonStore
        self.profileStore = profileStore
    }
}

extension ProfileInteractor: ProfileInteractorInput {

    func setSections() {
        guard let name = profileStore.profile?.name,
              let email = profileStore.profile?.email,
              let version = commonStore.version else {
            return
        }

        sections = [
            ProfileSection(
                title: name,
                description: email,
                rows: [
                    ProfileRow(
                        id: .support,
                        title: "Profile.support".localized,
                        image: .support,
                        accessoryImage: .arrowRight
                    ),
                    ProfileRow(
                        id: .logout,
                        title: "Profile.logout".localized,
                        image: .logout,
                        accessoryImage: nil
                    )
                ],
                value: "Common.appVersion".localized + " " + version
            )
        ]

        view.pass(sections: sections)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]

        switch row.id {
        case .support:
            view.dismissDrawer {
                guard let url = URL(string: Constants.supportUrl) else { return }
                UIApplication.shared.open(url)
            }
        case .logout:
            let okAction = BaseAlertAction(
                title: "Profile.logout".localized,
                isBold: true,
                isWarning: true
            ) { [weak self] in
                guard let interactor = self else { return }
                interactor.commonStore.clearAuthData()
                interactor.view.dismissDrawer(completion: nil)
            }
            let cancelAction = BaseAlertAction(title: "Common.cancel".localized)

            view.showAlert(
                title: "Common.attention".localized,
                message: "Profile.logoutInfo".localized,
                image: BaseImage.alertCircle.uiImage,
                yesAction: okAction,
                noAction: cancelAction
            )
        }
    }
}
