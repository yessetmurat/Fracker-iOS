//
//  AuthViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AuthenticationServices
import Base

class AuthViewController: BaseViewController {

    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let appleSignInButton = ASAuthorizationAppleIDButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(appleSignInButton)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        imageView.translatesAutoresizingMaskIntoConstraints = false
    	layoutConstraints += [
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -124),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    	]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ]

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [appleSignInButton.heightAnchor.constraint(equalToConstant: 54)]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        imageView.image = BaseImage.logo.uiImage
        imageView.contentMode = .scaleAspectFit
    }

    private func setActions() {
        appleSignInButton.addTarget(self, action: #selector(appleSignInButtonAction), for: .touchUpInside)
    }

    @objc private func appleSignInButtonAction() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]

        let viewController = ASAuthorizationController(authorizationRequests: [request])
        viewController.delegate = self
        viewController.performRequests()
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        interactor?.signInWithApple(authorization: authorization)
    }
}

extension AuthViewController: AuthViewInput {

    func set(isLoading: Bool) {

    }

    func configureSignIn() {

    }
}
