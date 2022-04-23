//
//  NetworkError + extensions.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation
import Network11

extension NetworkError {

    static var dataLoad: NetworkError {
        NetworkError(error: NSError(domain: "There was a problem during the data load", code: -11))
    }
}
