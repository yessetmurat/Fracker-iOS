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

    private func toDate(for filter: AnalyticsFilter, date: Date) -> Date? {
        let calendarComponent: Calendar.Component

        switch filter {
        case .week: calendarComponent = .weekOfMonth
        case .month: calendarComponent = .month
        case .year: calendarComponent = .year
        }

        guard let fromDate = Calendar.current.date(byAdding: calendarComponent, value: -1, to: date) else {
            return nil
        }
        return fromDate
    }

    private func predicate(for filter: AnalyticsFilter, date: Date) -> NSPredicate? {
        guard let fromDate = toDate(for: filter, date: date) else { return nil }

        return NSPredicate(
            format: "(createdAt >= %@) AND (createdAt <= %@)",
            fromDate as NSDate,
            date as NSDate
        )
    }

    private func totalAmount(for filter: AnalyticsFilter, date: Date) -> Decimal? {
        guard let predicate = predicate(for: filter, date: date),
              let localRecords: [LocalRecord] = try? localDatabaseManager.all(with: predicate) else {
            return nil
        }
        return localRecords.map { $0.amount.decimalValue }.reduce(0, +)
    }

    private func loadLocalAnalytics(filter: AnalyticsFilter, completion: (Result<Analytics, NetworkError>) -> Void) {
        let currentDate = Date()

        guard let predicate = predicate(for: filter, date: currentDate),
              let localRecords: [LocalRecord] = try? localDatabaseManager.all(with: predicate),
              let currentAmount = totalAmount(for: filter, date: currentDate),
              let previousDate = toDate(for: filter, date: currentDate) else {
            return completion(.failure(.unknown))
        }

        let previousAmount = totalAmount(for: filter, date: previousDate)

        let localCategories = localRecords.compactMap { $0.category }.unique
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
        }.sorted(by: { $0.amount > $1.amount })

        var didRise: Bool?
        var percent: Decimal = 0

        if let previousAmount = previousAmount, !previousAmount.isZero {
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
        filter: AnalyticsFilter,
        completion: @escaping (Result<Analytics, NetworkError>) -> Void
    ) {
        let networkContext = AnalyticsNetworkContext(filter: filter)
        networkService.performRequest(using: networkContext, completion: completion)
    }
}

extension AnalyticsWorker {

    func loadAnalytics(filter: AnalyticsFilter, completion: @escaping (Result<Analytics, NetworkError>) -> Void) {
        switch commonStore.authorizationStatus {
        case .authorized:
            loadRemoteAnalytics(filter: filter, completion: completion)
        case .none:
            loadLocalAnalytics(filter: filter, completion: completion)
        }
    }
}
