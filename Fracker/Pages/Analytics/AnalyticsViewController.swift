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
        title = "Analytics"
        view.backgroundColor = BaseColor.white

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
            interactor.setSections()
            interactor.loadAnalytics()
        }
    }
}

extension AnalyticsViewController {

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].id {
        case .total(let didRise, let percent):
            if isLoading {
                let headerView: ContentHeaderFooterView<AnalyticsAmountShimmerView> =
                    tableView.dequeueReusableHeaderFooter()
                headerView.setMargins(bottom: 4)
                headerView.view.startAnimating()
                return headerView
            }

            let headerView: ContentHeaderFooterView<AnalyticsAmountView> = tableView.dequeueReusableHeaderFooter()
            headerView.setMargins(bottom: 4)
            headerView.view.title = sections[section].title
            headerView.view.descriptionString = sections[section].description
            headerView.view.didRise = didRise
            headerView.view.percent = percent
            return headerView
        case .details:
            let headerView: ContentHeaderFooterView<SeparatorView> = tableView.dequeueReusableHeaderFooter()
            headerView.setMargins(top: 0, bottom: 0)
            return headerView
        }
    }
}

extension AnalyticsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]

        switch row.id {
        case .chart(let data, let filters, let selectedFilter):
            if isLoading {
                let cell: ContentCell<AnalyticsChartShimmerView> = tableView.dequeueReusableCell(for: indexPath)
                cell.setMargins(left: 0, right: 0)
                cell.contentSelectionStyle = .none
                cell.view.startAnimating()
                return cell
            }
            let cell: ContentCell<AnalyticsChartView> = tableView.dequeueReusableCell(for: indexPath)
            cell.setMargins(left: 0, right: 0)
            cell.contentSelectionStyle = .none
            cell.view.delegate = self
            cell.view.selectorDelegate = self
            cell.view.set(data: data, filters: filters, selectedFilter: selectedFilter)
            return cell
        case .category(let emoji, let amount):
            if isLoading {
                let cell: ContentCell<AnalyticsCategoryShimmerView> = tableView.dequeueReusableCell(for: indexPath)
                cell.view.startAnimating()
                return cell
            }
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
        tableView.backgroundView = sections.isEmpty ? NothingToShowView() : nil
    }

    func pass(isLoading: Bool) {
        self.isLoading = isLoading
    }

    func reloadData() {
        tableView.reloadData()
    }

    func update(row: AnalyticsRow, at indexPath: IndexPath) {
        sections[indexPath.section].rows[indexPath.row] = row

        switch row.id {
        case .chart(let data, let filters, let selectedFilter):
            guard let cell = tableView.cellForRow(at: indexPath) as? ContentCell<AnalyticsChartView> else { return }
            cell.view.set(data: data, filters: filters, selectedFilter: selectedFilter)
        default:
            return
        }
    }
}
