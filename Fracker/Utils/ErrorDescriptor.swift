//
//  ErrorDescriptor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation
import NetworkKit

class ErrorDescriptor {

    class func convert(_ response: NetworkResponse) -> DisplayedError {
        let text: String

        if let response = response as? FailureNetworkResponse,
           let json = response.json,
           let reason = json["reason"] as? String {
            return DisplayedError(text: reason, json: json)
        }

        if let networkError = response.error {
            return convert(networkError: networkError)
        } else if let error = response.error as NSError? {
            text = error.description
        } else {
            text = "Error.unknown".localized
        }

        return DisplayedError(text: text)
    }

    class func convert(networkError: NetworkError) -> DisplayedError {
        let text: String

        switch networkError {
        case .unknown: text = "Error.unknown".localized
        case .cancelled: text = "Error.cancelled".localized
        case .dataLoad: text = "Error.dataLoad".localized
        case .timedOut: text = "Error.timedOut".localized
        default: return convert(networkError: .unknown)
        }

        return DisplayedError(text: text)
    }

    class func convert(localError: LocalError) -> DisplayedError {
        let text: String

        switch localError {
        case .unknown: text = "Error.unknown".localized
        case .message(let string): text = string
        }

        return DisplayedError(text: text)
    }
}
