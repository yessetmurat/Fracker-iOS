//
//  LocalError.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation

enum LocalError: Error {

    case unknown
    case message(String)

    var description: String {
        switch self {
        case .unknown: return "The service is temporarily unavailable. Please try again later"
        case .message(let string): return string
        }
    }
}
