//
//  AnalyticsFilter.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

enum AnalyticsFilter: String, CaseIterable {

    case day, week, month, year

    var title: String {
        switch self {
        case .day: return "Analytics.day".localized
        case .week: return "Analytics.week".localized
        case .month: return "Analytics.month".localized
        case .year: return "Analytics.year".localized
        }
    }

    var description: String {
        switch self {
        case .week: return "Analytics.thisWeek".localized
        default: return title.lowercased()
        }
    }
}
