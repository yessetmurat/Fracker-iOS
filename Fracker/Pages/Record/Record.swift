//
//  Record.swift
//  Fracker
//
//  Created by Yesset Murat on 4/30/22.
//

import Foundation

struct Record: Decodable {

    let id: UUID
    let amount: Decimal
    let category: Category?
    let createdAt: Date?
}
