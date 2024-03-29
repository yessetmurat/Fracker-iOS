//
//  CategoriesNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import NetworkKit

class CategoriesNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiCategories }
    var method: NetworkMethod { .GET }
    var encoding: NetworkEncoding { .url }
}
