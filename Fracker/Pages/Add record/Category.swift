//
//  Category.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Foundation

struct Category: Codable, Hashable {

    let id: UUID
    let emoji: String
    let name: String
}

extension Category {

    var description: String { emoji + " " + name }
}
