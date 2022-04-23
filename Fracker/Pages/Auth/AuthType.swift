//
//  AuthType.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

enum AuthType {

    case signIn, signUp

    var title: String {
        switch self {
        case .signIn: return "Sign In"
        case .signUp: return "Sign Up"
        }
    }

    var revertedValue: AuthType {
        switch self {
        case .signIn: return .signUp
        case .signUp: return .signIn
        }
    }
}
