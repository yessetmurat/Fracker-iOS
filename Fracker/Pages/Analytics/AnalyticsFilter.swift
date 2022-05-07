//
//  AnalyticsFilter.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

enum AnalyticsFilter: String, CaseIterable {

    case week, month, year

    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}
