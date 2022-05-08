//
//  ProfileNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import NetworkKit

class ProfileNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiProfile }
    var method: NetworkMethod { .GET }
    var encoding: NetworkEncoding { .url }
}
