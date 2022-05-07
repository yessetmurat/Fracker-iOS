//
//  AnalyticsSection.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

struct AnalyticsSection {

    enum Identifier { case total(didRise: Bool? = nil, percent: String? = nil), details }

    let id: Identifier
    let title: String?
    let description: String?
    var rows: [AnalyticsRow]
}
