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
    }

    private func setActions() {
        tableView.register(ContentHeaderFooterView<AnalyticsAmountView>.self)
        tableView.register(ContentCell<AnalyticsChartView>.self)
    }
}

extension AnalyticsViewController {

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ContentHeaderFooterView<AnalyticsAmountView> = tableView.dequeueReusableHeaderFooter()
        headerView.setMargins(bottom: 4)
        return headerView
    }
}

extension AnalyticsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContentCell<AnalyticsChartView> = tableView.dequeueReusableCell(for: indexPath)
        cell.setMargins(left: 0, right: 0)
        return cell
    }
}

extension AnalyticsViewController: AnalyticsViewInput {

}
