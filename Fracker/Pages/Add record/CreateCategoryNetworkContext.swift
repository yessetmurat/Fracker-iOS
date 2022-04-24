//
//  CreateCategoryNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Network11

class CreateCategoryNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiCategories }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let parameters: [String: Any]

    init(name: String) {
        parameters = ["name": name]
    }
}
