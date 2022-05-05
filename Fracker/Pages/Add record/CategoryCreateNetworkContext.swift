//
//  CategoryCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation
import Network11

class CategoryCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiCategories }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(data: Category) {
        httpBody = try? JSONEncoder().encode(data)
    }
}
