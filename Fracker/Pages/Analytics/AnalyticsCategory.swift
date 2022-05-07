//
//  AnalyticsCategory.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

struct AnalyticsCategory: Decodable, Hashable {

    let id: UUID
    let emoji: String
    let name: String
    let recordsCount: Int
    let amount: Decimal
    let value: Float
}
