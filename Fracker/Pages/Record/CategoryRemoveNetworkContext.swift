//
//  CategoryRemoveNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import NetworkKit

class CategoryRemoveNetworkContext: NetworkContext {

    let endpoint: NetworkEndpoint
    var method: NetworkMethod { .DELETE }
    var encoding: NetworkEncoding { .url }

    init(id: String) {
        endpoint = Endpoint.apiCategoriesId(id: id)
    }
}
