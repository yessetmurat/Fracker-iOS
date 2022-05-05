//
//  CategoriesBatchCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/28/22.
//

import Foundation
import Network11

class CategoriesBatchCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiCategoriesBatch }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(categories: [Category]) {
        httpBody = try? JSONEncoder().encode(categories)
    }
}
