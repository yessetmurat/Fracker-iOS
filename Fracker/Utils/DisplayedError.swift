//
//  DisplayedError.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation

struct DisplayedError: Error {

    var title: String?
    let text: String
    var json: [String: Any]?
}
