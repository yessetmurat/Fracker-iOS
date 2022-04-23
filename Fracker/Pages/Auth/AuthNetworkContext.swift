//
//  AuthNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Network11

class AuthNetworkContext: NetworkContext {

    let endpoint: NetworkEndpoint
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let parameters: [String: Any]

    init(authType: AuthType, email: String, password: String) {
        endpoint = authType == .signIn ? Endpoint.apiSignIn : Endpoint.apiSignUp
        parameters = ["email": email, "password": password]
    }
}
