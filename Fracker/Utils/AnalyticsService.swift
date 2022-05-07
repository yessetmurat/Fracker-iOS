//
//  AnalyticsService.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation
import NetworkKit

protocol AnalyticsService {

    var commonStore: CommonStore { get }
    var networkService: NetworkService { get }

    func loadAnalytics(filter: AnalyticsFilter, completion: @escaping (Result<Analytics, NetworkError>) -> Void)
}
