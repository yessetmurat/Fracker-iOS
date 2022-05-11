//
//  AnalyticsWorker.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation
import NetworkKit

class AnalyticsWorker: AnalyticsService {

    unowned let commonStore: CommonStore
    let networkService: NetworkService

    private var localDatabaseManager: LocalDatabaseManager { commonStore.localDatabaseManager }

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
        networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
    }

    private func records(fromDate: Date, toDate: Date) -> [LocalRecord] {
        let predicate = NSPredicate(
            format: "(createdAt >= %@) AND (createdAt <= %@)",
            fromDate as NSDate,
            toDate as NSDate
        )

        guard let records: [LocalRecord] = try? localDatabaseManager.all(with: predicate) else { return [] }
        return records
    }

    private func loadLocalAnalytics(
        filterType: AnalyticsFilter,
        completion: (Result<Analytics, NetworkError>) -> Void
    ) {
        let currentDate = Date()
        let fromDate: Date?
        let calendarComponent: Calendar.Component

        switch filterType {
        case .day:
            fromDate = currentDate.startOfDay
            calendarComponent = .day
        case .week:
            fromDate = currentDate.startOfWeek
            calendarComponent = .weekOfMonth
        case .month:
            fromDate = currentDate.startOfMonth
            calendarComponent = .month
        case .year:
            fromDate = currentDate.startOfYear
            calendarComponent = .year
        }

        guard let fromDate = fromDate, let previousDate = fromDate.previous(calendarComponent) else {
            return completion(.failure(.dataLoad))
        }

        let currentRecords = records(fromDate: fromDate, toDate: currentDate)
        let previousRecords = records(fromDate: previousDate, toDate: fromDate)

        let currentAmount = currentRecords.compactMap { $0.amount.decimalValue }.reduce(0, +)
        let previousAmount = previousRecords.compactMap { $0.amount.decimalValue }.reduce(0, +)

        let localCategories = currentRecords.compactMap { $0.category }.unique
        let categories = localCategories.compactMap { localCategory -> AnalyticsCategory? in
            guard let recordsSet = localCategory.records, let records = recordsSet.allObjects as? [LocalRecord] else {
                return nil
            }

            let amount = records.map { $0.amount.decimalValue }.reduce(0, +)

            return AnalyticsCategory(
                id: localCategory.id,
                emoji: localCategory.emoji,
                name: localCategory.name,
                recordsCount: records.count,
                amount: amount,
                value: NSDecimalNumber(decimal: amount / currentAmount).floatValue
            )
        }.sorted { $0.amount > $1.amount }

        var didRise: Bool?
        var percent: Decimal = 0

        if !previousAmount.isZero {
            didRise = currentAmount > previousAmount
            percent = ((currentAmount - previousAmount) / currentAmount) * 100
        }

        let analytics = Analytics(
            total: currentAmount,
            didRise: didRise,
            percent: abs(percent).percent,
            categories: categories
        )
        completion(.success(analytics))
    }

    private func loadRemoteAnalytics(
        filterType: AnalyticsFilter,
        completion: @escaping (Result<Analytics, NetworkError>) -> Void
    ) {
        let networkContext = AnalyticsNetworkContext(filterType: filterType)
        networkService.performRequest(using: networkContext, completion: completion)
    }
}

extension AnalyticsWorker {

    func loadAnalytics(filterType: AnalyticsFilter, completion: @escaping (Result<Analytics, NetworkError>) -> Void) {
        switch commonStore.authorizationStatus {
        case .authorized:
            loadRemoteAnalytics(filterType: filterType, completion: completion)
        case .none:
            loadLocalAnalytics(filterType: filterType, completion: completion)
        }
    }
}
