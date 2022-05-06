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

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {

    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

    	layoutConstraints += [
    	]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {

    }

    private func setActions() {

    }
}

extension ProfileViewController: ProfileViewInput {

}
