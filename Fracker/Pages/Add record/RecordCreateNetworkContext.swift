//
//  RecordCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import Network11

class RecordCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiRecords }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(data: RecordData) {
        httpBody = try? JSONEncoder().encode(data)
    }
}
