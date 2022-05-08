//
//  ProfileViewInput.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import BaseKit

protocol ProfileViewInput: BaseViewInput, DrawerContentViewControllerProtocol {

    func pass(sections: [ProfileSection])
}
