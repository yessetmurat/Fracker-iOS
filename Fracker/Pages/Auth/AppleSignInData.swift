//
//  AppleSignInData.swift
//  Fracker
//
//  Created by Yesset Murat on 4/25/22.
//

struct AppleSignInData: Encodable {

    let idToken: String
    let firstName: String?
    let lastName: String?
}
