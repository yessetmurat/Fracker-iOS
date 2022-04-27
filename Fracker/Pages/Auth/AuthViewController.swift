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
    private let loadingStackView = UIStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    private let signInStackView = UIStackView()
    private let appleSignInButton = ASAuthorizationAppleIDButton()

    private lazy var signInStackViewTopConstraint = signInStackView.topAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: 32
    )
    private lazy var signInStackViewBottomConstraint = signInStackView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -32
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(loadingLabel)
        loadingStackView.addArrangedSubview(activityIndicatorView)
        view.addSubview(signInStackView)
        signInStackView.addArrangedSubview(appleSignInButton)
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

        loadingStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            loadingStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            loadingStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            loadingStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ]

        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [loadingLabel.heightAnchor.constraint(equalToConstant: 54)]

        signInStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            signInStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            signInStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            signInStackViewBottomConstraint
        ]

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [appleSignInButton.heightAnchor.constraint(equalToConstant: 54)]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        imageView.image = BaseImage.logo.uiImage
        imageView.contentMode = .scaleAspectFit

        loadingStackView.alpha = 0
        loadingStackView.axis = .vertical
        loadingStackView.spacing = 8

        loadingLabel.text = "Signing in..."
        loadingLabel.font = BaseFont.regular
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = BaseColor.gray

        activityIndicatorView.color = BaseColor.blue
        activityIndicatorView.hidesWhenStopped = false

        signInStackView.axis = .vertical
        signInStackView.spacing = 24
    }

    private func setActions() {
        appleSignInButton.addTarget(self, action: #selector(appleSignInButtonAction), for: .touchUpInside)
    }

    private func dismissSignInStackViewAnimated() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) { [weak self] in
            guard let viewController = self else { return }
            viewController.signInStackViewBottomConstraint.isActive = false
            viewController.signInStackViewTopConstraint.isActive = true
            viewController.view.layoutIfNeeded()
        }
    }

    private func presentLoadingStackViewAnimated() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) { [weak self] in
            guard let viewController = self else { return }
            viewController.loadingStackView.alpha = 1
            viewController.activityIndicatorView.startAnimating()
        }
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

    func startLoading() {
        dismissSignInStackViewAnimated()
        presentLoadingStackViewAnimated()
    }

    func configureSignIn() {

    }
}
