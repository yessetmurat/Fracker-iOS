//
//  AnalyticsRow.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

struct AnalyticsRow {

    enum Identifier {

        case chart(
            data: Chart? = nil,
            filters: [AnalyticsFilter] = AnalyticsFilter.allCases,
            selectedFilter: AnalyticsFilter = .day
        )
        case category(emoji: String? = nil, amount: String? = nil)
    }

    var id: Identifier
    let title: String?
    let description: String?
}
