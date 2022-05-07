//
//  AnalyticsChartViewDelegate.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

protocol AnalyticsChartViewDelegate: AnyObject {

    func analyticsChartView(_ analyticsChartView: AnalyticsChartView, didSelectItemIndex index: Int)
}
