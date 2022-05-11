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
    private var selectedFilter: AnalyticsFilter = .day

    private var currency: String { Locale.current.currencySymbol ?? "" }

    init(view: AnalyticsViewInput, commonStore: CommonStore, analyticsService: AnalyticsService) {
        self.view = view
        self.commonStore = commonStore
        self.analyticsService = analyticsService
    }

    private func loadAnalytics(completion: @escaping () -> Void) {
        analyticsService.loadAnalytics(filterType: selectedFilter) { [weak self] result in
            guard let interactor = self else { return }
            defer { completion() }
            interactor.view.pass(isLoading: false)

            switch result {
            case .success(let analytics):
                guard !analytics.categories.isEmpty, let totalSection = interactor.totalSection(from: analytics) else {
                    return
                }

                interactor.sections = [
                    totalSection,
                    interactor.detailsSection(from: analytics)
                ]
            case .failure(let error):
                interactor.show(networkError: error, view: interactor.view)
            }
        }
    }

    private func totalSection(from analytics: Analytics) -> AnalyticsSection? {
        guard let amount = analytics.total.optionalFractionDisplayedAmount,
              let average = (analytics.total / 2).short,
              let maximum = analytics.total.short else {
            return nil
        }

        let row = AnalyticsRow(
            id: .chart(
                data: Chart(
                    minimum: "0",
                    average: average,
                    maximum: maximum,
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
            title: amount + currency,
            description: "Analytics.spend".localized + " " + selectedFilter.description,
            rows: [row]
        )
    }

    private func detailsSection(from analytics: Analytics) -> AnalyticsSection {
        return AnalyticsSection(
            id: .details,
            title: nil,
            description: nil,
            rows: analytics.categories.compactMap(convert)
        )
    }

    private func convert(_ category: AnalyticsCategory) -> Chart.Item {
        return Chart.Item(title: category.emoji, value: category.value)
    }

    private func convert(_ category: AnalyticsCategory) -> AnalyticsRow? {
        guard let amount = category.amount.optionalFractionDisplayedAmount else { return nil }

        return AnalyticsRow(
            id: .category(emoji: category.emoji, amount: amount + currency),
            title: category.name,
            description: category.recordsCount.description + " " + "Analytics.records".localized
        )
    }
}

extension AnalyticsInteractor: AnalyticsInteractorInput {

    func loadAnalytics() {
        loadAnalytics { [weak self] in
            guard let interactor = self else { return }
            interactor.view.pass(sections: interactor.sections)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak interactor] in
                interactor?.view.reloadData()
            }
        }
    }

    func didSelectFilter(at index: Int) {
        guard selectedFilter != filters[index] else { return }
        selectedFilter = filters[index]

        guard let totalSectionIndex = sections.firstIndex(where: { section -> Bool in
            guard case .total = section.id else { return false }
            return true
        }) else {
            return
        }

        sections[totalSectionIndex].isLoading = true
        view.update(section: sections[totalSectionIndex], at: totalSectionIndex)

        loadAnalytics { [weak self] in
            guard let interactor = self else { return }

            interactor.sections[totalSectionIndex].isLoading = false
            interactor.view.update(section: interactor.sections[totalSectionIndex], at: totalSectionIndex)

            if let index = interactor.sections.firstIndex(where: { section -> Bool in
                guard case .details = section.id else { return false }
                return true
            }) {
                interactor.view.update(section: interactor.sections[index], at: index)
            }
        }
    }
}
