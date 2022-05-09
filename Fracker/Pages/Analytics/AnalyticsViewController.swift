//
//  AnalyticsViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import BaseKit

class AnalyticsViewController: BaseTableViewController {

    var interactor: AnalyticsInteractorInput?
    var router: AnalyticsRouterInput?

    private var sections: [AnalyticsSection] = []
    private var isLoading = true

    override func viewDidLoad() {
        super.viewDidLoad()

        stylize()
        setActions()
    }

    private func stylize() {
        title = "Analytics.title".localized
        view.backgroundColor = BaseColor.white

        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView(frame: UIConstants.invisibleViewFrame)
        tableView.tableFooterView = UIView(frame: UIConstants.invisibleViewFrame)
        tableView.sectionFooterHeight = 0
    }

    private func setActions() {
        tableView.register(ContentHeaderFooterView<AnalyticsAmountShimmerView>.self)
        tableView.register(ContentHeaderFooterView<AnalyticsAmountView>.self)
        tableView.register(ContentCell<AnalyticsChartShimmerView>.self)
        tableView.register(ContentCell<AnalyticsChartView>.self)
        tableView.register(ContentHeaderFooterView<SeparatorView>.self)
        tableView.register(ContentCell<AnalyticsCategoryShimmerView>.self)
        tableView.register(ContentCell<AnalyticsCategoryView>.self)

        if let interactor = interactor {
            interactor.loadAnalytics()
        }
    }
}

extension AnalyticsViewController {

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading {
            if section == 0 {
                let headerView: ContentHeaderFooterView<AnalyticsAmountShimmerView> =
                tableView.dequeueReusableHeaderFooter()
                headerView.setMargins(bottom: 4)
                headerView.view.startAnimating()
                return headerView
            } else {
                return nil
            }
        }

        switch sections[section].id {
        case .total(let didRise, let percent):
            let headerView: ContentHeaderFooterView<AnalyticsAmountView> = tableView.dequeueReusableHeaderFooter()
            headerView.setMargins(bottom: 4)
            headerView.view.title = sections[section].title
            headerView.view.descriptionString = sections[section].description
            headerView.view.didRise = didRise
            headerView.view.percent = percent
            headerView.view.isLoading = sections[section].isLoading
            return headerView
        case .details:
            let headerView: ContentHeaderFooterView<SeparatorView> = tableView.dequeueReusableHeaderFooter()
            headerView.setMargins(top: 0, bottom: 0)
            return headerView
        }
    }
}

extension AnalyticsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int { isLoading ? 2 : sections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return section == 0 ? 1 : 3
        }
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            if indexPath.section == 0 {
                let cell: ContentCell<AnalyticsChartShimmerView> = tableView.dequeueReusableCell(for: indexPath)
                cell.setMargins(left: 0, right: 0)
                cell.contentSelectionStyle = .none
                cell.view.startAnimating()
                return cell
            } else {
                let cell: ContentCell<AnalyticsCategoryShimmerView> = tableView.dequeueReusableCell(for: indexPath)
                cell.contentSelectionStyle = .none
                cell.view.startAnimating()
                return cell
            }
        }

        let row = sections[indexPath.section].rows[indexPath.row]

        switch row.id {
        case .chart(let data, let filters, let selectedFilter):
            let cell: ContentCell<AnalyticsChartView> = tableView.dequeueReusableCell(for: indexPath)
            cell.setMargins(left: 0, right: 0)
            cell.contentSelectionStyle = .none
            cell.view.delegate = self
            cell.view.selectorDelegate = self
            cell.view.set(data: data)
            cell.view.selectorTitles = filters.map { $0.title }
            cell.view.selectorSelectedIndex = filters.firstIndex(of: selectedFilter)
            return cell
        case .category(let emoji, let amount):
            let cell: ContentCell<AnalyticsCategoryView> = tableView.dequeueReusableCell(for: indexPath)
            cell.view.emoji = emoji
            cell.view.title = row.title
            cell.view.descriptionString = row.description
            cell.view.amount = amount
            return cell
        }
    }
}

extension AnalyticsViewController: AnalyticsChartViewDelegate {

    func analyticsChartView(_ analyticsChartView: AnalyticsChartView, didSelectItemIndex index: Int) {

    }
}

extension AnalyticsViewController: SelectorViewDelegate {

    func selectorView(_ selectorView: SelectorView, didSelectItemAtIndex index: Int) {
        interactor?.didSelectFilter(at: index)
    }
}

extension AnalyticsViewController: AnalyticsViewInput {

    func pass(sections: [AnalyticsSection]) {
        self.sections = sections
    }

    func pass(isLoading: Bool) {
        self.isLoading = isLoading
    }

    func reloadData() {
        if sections.isEmpty {
            tableView.reloadData()
        } else {
            let indexSets = sections.indices.map { IndexSet(integer: $0) }
            tableView.performBatchUpdates {
                indexSets.forEach { tableView.reloadSections($0, with: .fade) }
            }
        }

        tableView.backgroundView = sections.isEmpty ? NothingToShowView() : nil
    }

    func update(section: AnalyticsSection, at index: Int) {
        self.sections[index] = section

        switch section.id {
        case .total(let didRise, let percent):
            if let headerView =
                tableView.headerView(forSection: index) as? ContentHeaderFooterView<AnalyticsAmountView> {
                headerView.view.title = section.title
                headerView.view.descriptionString = section.description
                headerView.view.didRise = didRise
                headerView.view.percent = percent
                headerView.view.isLoading = section.isLoading
            }

            for (rowIndex, row) in section.rows.enumerated() {
                let indexPath = IndexPath(row: rowIndex, section: index)

                if case .chart(let data, _, _) = row.id,
                   let cell = tableView.cellForRow(at: indexPath) as? ContentCell<AnalyticsChartView> {
                    cell.view.set(data: data)
                }
            }
        case .details:
            tableView.reloadSections(IndexSet(integer: index), with: .automatic)
        }
    }
}
