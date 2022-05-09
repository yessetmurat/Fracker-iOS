//
//  AuthViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AuthenticationServices
import BaseKit
import GoogleSignIn

class AuthViewController: BaseViewController {

    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private var isLoading = false

    private let loadingStackView = UIStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    private let signInStackView = UIStackView()
    private let googleSignInButton = UIButton(type: .system)
    private let appleSignInButton = ASAuthorizationAppleIDButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(loadingLabel)
        loadingStackView.addArrangedSubview(activityIndicatorView)
        view.addSubview(signInStackView)
        signInStackView.addArrangedSubview(googleSignInButton)
        signInStackView.addArrangedSubview(appleSignInButton)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        loadingStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            loadingStackView.centerYAnchor.constraint(equalTo: signInStackView.centerYAnchor),
            loadingStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            loadingStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            loadingStackView.heightAnchor.constraint(equalToConstant: 58)
        ]

        signInStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            signInStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 24),
            signInStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24
            ),
            signInStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            signInStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
        ]

        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [googleSignInButton.heightAnchor.constraint(equalToConstant: 54)]

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [appleSignInButton.heightAnchor.constraint(equalToConstant: 54)]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        loadingStackView.alpha = 0
        loadingStackView.axis = .vertical
        loadingStackView.spacing = 16

        loadingLabel.font = BaseFont.semibold
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = BaseColor.gray

        activityIndicatorView.color = BaseColor.blue
        activityIndicatorView.hidesWhenStopped = false

        signInStackView.axis = .vertical
        signInStackView.spacing = 16

        googleSignInButton.backgroundColor = BaseColor.blue
        googleSignInButton.setImage(
            BaseImage.google.uiImage?.fitThenCenter(in: CGSize(width: 16, height: 16)), for: .normal
        )
        googleSignInButton.setTitle("Auth.google".localized, for: .normal)
        googleSignInButton.tintColor = BaseColor.white
        googleSignInButton.titleLabel?.font = BaseFont.medium.withSize(20)
        googleSignInButton.titleEdgeInsets.left = 15
        googleSignInButton.layer.cornerRadius = 10

        appleSignInButton.cornerRadius = 10
    }

    private func setActions() {
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonAction), for: .touchUpInside)
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
            viewController.signInStackView.alpha = 0
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

    @objc private func googleSignInButtonAction() {
        interactor?.signInWithGoogle()
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

extension AuthViewController {

    var contentViewHeight: CGFloat { 24 + signInStackView.bounds.height + 24 }

    var isDismissEnabled: Bool { !isLoading }
}

extension AuthViewController: AuthViewInput {

    func startLoading() {
        dismissSignInStackViewAnimated()
        presentLoadingStackViewAnimated()
        self.isLoading = true
    }

    func set(statusText: String) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .moveIn
        animation.subtype = .fromTop
        animation.duration = 0.4
        loadingLabel.layer.add(animation, forKey: CATransitionType.moveIn.rawValue)

        loadingLabel.text = statusText
    }

    func reloadParentData() {
        router?.reloadParentData()
    }
}
