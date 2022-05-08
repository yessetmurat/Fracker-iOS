//
//  AuthViewInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import BaseKit

protocol AuthViewInput: BaseViewInput, DrawerContentViewControllerProtocol {

    func startLoading()
    func set(statusText: String)
    func reloadParentData()
}
