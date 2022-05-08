//
//  CategoriesBatchCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/28/22.
//

import Foundation
import NetworkKit

class CategoriesBatchCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiCategoriesBatch }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(categories: [Category]) {
        httpBody = categories.encode()
    }
}
