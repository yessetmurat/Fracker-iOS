//
//  InitialInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import NetworkKit

class InitialInteractor {

    private unowned let view: InitialViewInput
    private unowned let commonStore: CommonStore
    private unowned let profileStore: ProfileStore
    private let networkService: NetworkService

    init(
        view: InitialViewInput,
        commonStore: CommonStore,
        profileStore: ProfileStore,
        networkService: NetworkService
    ) {
        self.view = view
        self.commonStore = commonStore
        self.profileStore = profileStore
        self.networkService = networkService
    }
}

extension InitialInteractor: InitialInteractorInput {

    func loadProfile() {
        switch commonStore.authorizationStatus {
        case .authorized:
            let networkContext = ProfileNetworkContext()
            networkService.performRequest(using: networkContext) { [weak self] response in
                guard let interactor = self else { return }
                defer { interactor.view.routeToRecordPage() }

                guard response.statusCode != 401, let profile: Profile = response.decode() else {
                    return interactor.commonStore.clearAuthData()
                }

                interactor.profileStore.profile = profile
            }
        case .none:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.view.routeToRecordPage() }
        }
    }
}
