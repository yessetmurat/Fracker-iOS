//
//  AnalyticsInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

class AnalyticsInteractor {

    private unowned let view: AnalyticsViewInput
    private unowned let commonStore: CommonStore
    private let analyticsService: AnalyticsService
    private var sections: [AnalyticsSection] = []
    private var filters: [AnalyticsFilter] = AnalyticsFilter.allCases
    private var selectedFilter: AnalyticsFilter = .week

    init(view: AnalyticsViewInput, commonStore: CommonStore) {
        self.view = view
        self.commonStore = commonStore
        analyticsService = AnalyticsWorker(commonStore: commonStore)
    }

    private func totalSection(from analytics: Analytics) -> AnalyticsSection {
        let row = AnalyticsRow(
            id: .chart(
                data: Chart(
                    minimum: "0",
                    average: (analytics.total / Decimal(2)).short ?? "",
                    maximum: analytics.total.short ?? "",
                    items: analytics.categories.map(convert)
                ),
                filters: filters,
                selectedFilter: selectedFilter
            ),
            title: nil,
            description: nil
        )
        return AnalyticsSection(
            id: .total(didRise: analytics.didRise, percent: analytics.percent),
            title: (analytics.total.displayedAmount ?? "") + "₸",
            description: "Total spend this " + selectedFilter.title.lowercased(),
            rows: [row]
        )
    }

    private func detailsSection(from analytics: Analytics) -> AnalyticsSection {
        return AnalyticsSection(
            id: .details,
            title: nil,
            description: nil,
            rows: analytics.categories.map(convert)
        )
    }

    private func convert(_ category: AnalyticsCategory) -> Chart.Item {
        return Chart.Item(title: category.emoji, value: category.value)
    }

    private func convert(_ category: AnalyticsCategory) -> AnalyticsRow {
        return AnalyticsRow(
            id: .category(emoji: category.emoji, amount: (category.amount.displayedAmount ?? "") + "₸"),
            title: category.name,
            description: category.recordsCount.description + " record(s)"
        )
    }
}

extension AnalyticsInteractor: AnalyticsInteractorInput {

    func setSections() {
        sections = [
            AnalyticsSection(
                id: .total(),
                title: nil,
                description: nil,
                rows: [
                    AnalyticsRow(
                        id: .chart(),
                        title: nil,
                        description: nil
                    )
                ]
            ),
            AnalyticsSection(
                id: .details,
                title: nil,
                description: nil,
                rows: [
                    AnalyticsRow(id: .category(), title: nil, description: nil),
                    AnalyticsRow(id: .category(), title: nil, description: nil),
                    AnalyticsRow(id: .category(), title: nil, description: nil)
                ]
            )
        ]

        view.pass(sections: sections)
    }

    func loadAnalytics() {
        analyticsService.loadAnalytics(filter: selectedFilter) { [weak self] result in
            guard let interactor = self else { return }

            defer {
                interactor.view.pass(isLoading: false)
                interactor.view.reloadData()
            }

            switch result {
            case .success(let analytics):
                guard !analytics.categories.isEmpty else {
                    return interactor.view.pass(sections: [])
                }

                interactor.sections = [
                    interactor.totalSection(from: analytics),
                    interactor.detailsSection(from: analytics)
                ]
                interactor.view.pass(sections: interactor.sections)
            case .failure(let error):
                interactor.show(networkError: error, view: interactor.view)
            }
        }
    }

    func didSelectFilter(at index: Int) {
        guard selectedFilter != filters[index] else { return }
        selectedFilter = filters[index]
        loadAnalytics()
    }
}
