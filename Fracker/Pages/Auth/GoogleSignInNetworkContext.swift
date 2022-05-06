//
//  GoogleSignInNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//

import Foundation
import NetworkKit

class GoogleSignInNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiAuthGoogle }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(data: SignInData) {
        httpBody = try? JSONEncoder().encode(data)
    }
}
