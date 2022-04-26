//
//  Endpoint.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Network11

enum Endpoint: NetworkEndpoint {

    case apiAuthApple

    case apiCategories
    case apiCategoriesId(id: String)

    var serverUrl: String { Constants.serverUrl }

    var apiUrl: String {
        switch self {
        case .apiAuthApple: return "/api/auth/apple"

        case .apiCategories: return "/api/categories"
        case .apiCategoriesId(let id): return "/api/categories/" + id
        }
    }
}
