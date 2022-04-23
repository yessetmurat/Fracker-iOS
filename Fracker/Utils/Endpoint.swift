//
//  Endpoint.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Network11

enum Endpoint: NetworkEndpoint {

    // MARK: - Auth
    case apiSignIn
    case apiSignUp

    case apiCategories

    var serverUrl: String { Constants.serverUrl }

    var apiUrl: String {
        switch self {
        case .apiSignIn: return "/api/users/sign-in"
        case .apiSignUp: return "/api/users/sign-up"

        case .apiCategories: return "/api/categories"
        }
    }
}
