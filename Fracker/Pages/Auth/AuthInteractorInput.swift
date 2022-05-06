//
//  AuthInteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import AuthenticationServices

protocol AuthInteractorInput: AnyObject, InteractorInput {

    func signInWithApple(authorization: ASAuthorization)
    func signInWithGoogle()
}
