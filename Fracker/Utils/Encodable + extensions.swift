//
//  Encodable + extensions.swift
//  Fracker
//
//  Created by Yesset Murat on 5/9/22.
//

import Foundation

extension Encodable {

    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }
}
