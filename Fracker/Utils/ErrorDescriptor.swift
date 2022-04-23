//
//  ErrorDescriptor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation
import Network11

class ErrorDescriptor {

    class func convert(_ response: NetworkResponse) -> DisplayedError {
        let text: String

        if let response = response as? FailureNetworkResponse, let json = response.json {
            let unknownErrorDescriptions = [
                "Something goes wrong. User Server response failed.",
                "Incorrect login or password",
                "The number of incorrect passwords has been exceeded! Your account has been temporarily suspended!",
                "user blocked"
            ]
            let errorKeys = ["description", "error_description", "value", "errorMessage"]
            if response.statusCode == 401 && json["error"] as? String == "unauthorized",
               let errorDescription = json["reason"] as? String,
               unknownErrorDescriptions.contains(errorDescription) {
                return DisplayedError(text: "The service is temporarily unavailable. Please try again later")
            } else if let errorKey = errorKeys.first(where: { json[$0] != nil }),
                      let errorDescription = json[errorKey] as? String {
                return DisplayedError(text: errorDescription, json: json)
            }
        }

        if let networkError = response.error {
            return convert(networkError: networkError)
        } else if let error = response.error as NSError? {
            text = error.description
        } else {
            text = "The service is temporarily unavailable. Please try again later"
        }

        return DisplayedError(text: text)
    }

    class func convert(networkError: NetworkError) -> DisplayedError {
        let text: String

        switch networkError {
        case .unknown: text = "The service is temporarily unavailable. Please try again later"
        case .cancelled: text = "Unexpected error!"
        case .dataLoad: text = "There was a problem during the data load"
        case .timedOut: text = "The request timed out"
        default: return convert(networkError: .unknown)
        }

        return DisplayedError(text: text)
    }

    class func convert(localError: LocalError) -> DisplayedError {
        let text: String

        switch localError {
        case .unknown: text = "he service is temporarily unavailable. Please try again later"
        case .message(let string): text = string
        }

        return DisplayedError(text: text)
    }
}
