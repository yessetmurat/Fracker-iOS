//
//  ProfileInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

class ProfileInteractor {

    private unowned let view: ProfileViewInput

    init(view: ProfileViewInput) {
        self.view = view
    }
}

extension ProfileInteractor: ProfileInteractorInput {

}
