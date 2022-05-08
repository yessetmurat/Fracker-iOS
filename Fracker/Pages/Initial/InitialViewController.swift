//
//  InitialViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import BaseKit

class InitialViewController: BaseViewController {

    var interactor: InitialInteractorInput?
    var router: InitialRouterInput?

    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += imageView.getLayoutConstraintsByCentering(over: view)
    	layoutConstraints += [
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
    	]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        imageView.image = BaseImage.logo.uiImage
        imageView.contentMode = .scaleAspectFit
    }

    private func setActions() {
        if let interactor = interactor {
            interactor.loadProfile()
        }
    }
}

extension InitialViewController: InitialViewInput {

    func routeToRecordPage() {
        router?.routeToRecordPage()
    }
}
