//
//  RecordCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import NetworkKit

class RecordCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiRecords }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(data: RecordRequestData) {
        httpBody = try? JSONEncoder().encode(data)
    }
}
