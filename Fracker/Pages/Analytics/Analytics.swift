//
//  Analytics.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

struct Analytics: Decodable {

    let total: Decimal
    let didRise: Bool?
    let percent: String
    let categories: [AnalyticsCategory]
}
