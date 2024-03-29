//
//  AppleSignInNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Foundation
import NetworkKit

class AppleSignInNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiAuthApple }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(data: SignInData) {
        httpBody = data.encode()
    }
}
