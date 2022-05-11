//
//  AnalyticsNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import NetworkKit

class AnalyticsNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiAnalytics }
    var method: NetworkMethod { .GET }
    var encoding: NetworkEncoding { .url }
    let parameters: [String: Any]

    init(filterType: AnalyticsFilter) {
        parameters = ["filter": filterType.rawValue]
    }
}
