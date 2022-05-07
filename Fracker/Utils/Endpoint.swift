//
//  Endpoint.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import NetworkKit

enum Endpoint: NetworkEndpoint {

    case apiAuthApple
    case apiAuthGoogle

    case apiCategories
    case apiCategoriesBatch
    case apiCategoriesId(id: String)

    case apiRecords
    case apiRecordsBatch

    case apiAnalytics

    var serverUrl: String { Constants.serverUrl }

    var apiUrl: String {
        switch self {
        case .apiAuthApple: return "/api/auth/apple"
        case .apiAuthGoogle: return "/api/auth/google"

        case .apiCategories: return "/api/categories"
        case .apiCategoriesBatch: return "/api/categories/batch"
        case .apiCategoriesId(let id): return "/api/categories/" + id

        case .apiRecords: return "/api/records"
        case .apiRecordsBatch: return "/api/records/batch"

        case .apiAnalytics: return "/api/analytics"
        }
    }
}
