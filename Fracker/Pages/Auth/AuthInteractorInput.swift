//
//  AuthInteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol AuthInteractorInput: AnyObject, InteractorInput {

    func signIn(email: String, password: String)
    func signUp(email: String, password: String, confirmPassword: String)
}
