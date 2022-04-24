//
//  CommonStore.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Foundation
import Network11

class CommonStore {

    let keyValueStore = KeyValueStore()

    let localDatabaseManager = LocalDatabaseManager()

    let sessionAdapter = NetworkSessionAdapter()

    let sessionConfiguarion = URLSessionConfiguration.default

    let session: URLSession

    var accessToken: String? {
        didSet {
            updateAdditionalHTTPHeaders()
        }
    }

    var additionalHTTPHeaders: [String: String] {
        var headers = [String: String]()

        if let accessToken = accessToken {
            headers["Authorization"] = "Bearer " + accessToken
        }

        return headers
    }

    var isAuthorized: Bool { accessToken != nil }

    private var sslCertDataItems: [NSData] {
        var sslCertUrls: [URL] = []

        if let urls = Bundle.main.urls(forResourcesWithExtension: "crt", subdirectory: nil) {
            sslCertUrls.append(contentsOf: urls)
        }

        return sslCertUrls.compactMap { NSData(contentsOfFile: $0.path) }
    }

    init() {
        sessionConfiguarion.timeoutIntervalForRequest = 30
        session = URLSession(configuration: sessionConfiguarion, delegate: sessionAdapter, delegateQueue: .main)
        sessionAdapter.session = session
        sessionAdapter.certDataItems = sslCertDataItems

        accessToken = keyValueStore.getValue(for: .token)

        updateAdditionalHTTPHeaders()

        Network11.Globals.networkLoggingEnabled = true
    }

    private func updateAdditionalHTTPHeaders() {
        sessionAdapter.additionalHTTPHeaders = additionalHTTPHeaders
    }
}
