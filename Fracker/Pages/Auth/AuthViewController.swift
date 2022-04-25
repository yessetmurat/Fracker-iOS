//
//  AuthViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Base

class AuthViewController: BaseViewController {

    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let imageView = UIImageView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(imageView)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        imageView.translatesAutoresizingMaskIntoConstraints = false
    	layoutConstraints += [
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    	]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        imageView.image = BaseImage.logo.uiImage
        imageView.contentMode = .scaleAspectFit
    }

    private func setActions() {

    }
}

extension AuthViewController: AuthViewInput {

    func set(isLoading: Bool) {

    }

    func configureSignIn() {

    }
}
