//
//  RecordsBatchCreateNetworkContext.swift
//  Fracker
//
//  Created by Yesset Murat on 5/5/22.
//

import Foundation
import NetworkKit

class RecordsBatchCreateNetworkContext: NetworkContext {

    var endpoint: NetworkEndpoint { Endpoint.apiRecordsBatch }
    var method: NetworkMethod { .POST }
    var encoding: NetworkEncoding { .json }
    let httpBody: Data?

    init(records: [RecordRequestData]) {
        httpBody = try? JSONEncoder().encode(records)
    }
}
