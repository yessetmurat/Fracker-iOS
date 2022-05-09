//
//  ProfileViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import BaseKit

class ProfileViewController: BaseViewController {

    var interactor: ProfileInteractorInput?
    var router: ProfileRouterInput?

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var sections: [ProfileSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.layout(over: view, safe: false)
        stylize()
        setActions()
    }

    private func stylize() {
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = BaseColor.white
        tableView.separatorColor = BaseColor.lightGray
        tableView.separatorInset.left = 24
        tableView.tableHeaderView = UIView(frame: UIConstants.invisibleViewFrame)
        tableView.tableFooterView = UIView(frame: UIConstants.invisibleViewFrame)
    }

    private func setActions() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContentHeaderFooterView<ProfileView>.self)
        tableView.register(ContentCell<ProfileActionView>.self)
        tableView.register(ContentHeaderFooterView<LabelView>.self)

        if let interactor = interactor {
            interactor.setSections()
        }
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ContentHeaderFooterView<ProfileView> = tableView.dequeueReusableHeaderFooter()
        headerView.view.title = sections[section].title
        headerView.view.descriptionString = sections[section].description
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: ContentHeaderFooterView<LabelView> = tableView.dequeueReusableHeaderFooter()
        footerView.setMargins(top: 8, bottom: 8)
        footerView.view.text = sections[section].value
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContentCell<ProfileActionView> = tableView.dequeueReusableCell(for: indexPath)
        cell.setMargins(right: 0)
        cell.view.image = sections[indexPath.section].rows[indexPath.row].image.uiImage
        cell.view.title = sections[indexPath.section].rows[indexPath.row].title
        cell.view.accessoryImage = sections[indexPath.section].rows[indexPath.row].accessoryImage?.uiImage
        return cell
    }
}

extension ProfileViewController {

    var contentViewHeight: CGFloat { tableView.contentSize.height }
}

extension ProfileViewController: ProfileViewInput {

    func pass(sections: [ProfileSection]) {
        self.sections = sections
    }
}
