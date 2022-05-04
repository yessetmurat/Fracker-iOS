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
    case apiCategoriesBatch
    case apiCategoriesId(id: String)

    case apiRecords
    case apiRecordsBatch

    var serverUrl: String { Constants.serverUrl }

    var apiUrl: String {
        switch self {
        case .apiAuthApple: return "/api/auth/apple"

        case .apiCategories: return "/api/categories"
        case .apiCategoriesBatch: return "/api/categories/batch"
        case .apiCategoriesId(let id): return "/api/categories/" + id

        case .apiRecords: return "/api/records"
        case .apiRecordsBatch: return "/api/records/batch"
        }
    }
}
