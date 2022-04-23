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

    override var baseModalPresentationStyle: UIModalPresentationStyle { .pageSheet }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let emailTextView = BaseTextView<UUID>()
    private let passwordTextView = BaseTextView<UUID>()
    private let confirmPasswordTextView = BaseTextView<UUID>()
    private let authToggleButton = UIButton()
    private let authButton = BaseButton()

    private var authType: AuthType = .signIn

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
        stackView.addArrangedSubview(emailTextView)
        stackView.addArrangedSubview(passwordTextView)
        stackView.addArrangedSubview(confirmPasswordTextView)
        stackView.addArrangedSubview(authToggleButton)
        view.addSubview(authButton)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        imageView.translatesAutoresizingMaskIntoConstraints = false
    	layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    	]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 64),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
        ]

        [emailTextView, passwordTextView, confirmPasswordTextView].forEach { textView in
            textView.translatesAutoresizingMaskIntoConstraints = false
            layoutConstraints += [
                textView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
                textView.heightAnchor.constraint(equalToConstant: 54)
            ]
        }

        authToggleButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            authToggleButton.widthAnchor.constraint(equalToConstant: 80),
            authToggleButton.heightAnchor.constraint(equalToConstant: 24)
        ]

        authButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            authButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            authButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            authButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        imageView.image = BaseImage.logo.uiImage
        imageView.contentMode = .scaleAspectFit

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .trailing

        emailTextView.placeholder = "Email"
        emailTextView.keyboardType = .emailAddress

        passwordTextView.placeholder = "Password"
        passwordTextView.isSecureTextEntry = true

        confirmPasswordTextView.placeholder = "Confirm password"
        confirmPasswordTextView.isSecureTextEntry = true
        confirmPasswordTextView.isHidden = true
        confirmPasswordTextView.alpha = 0

        authToggleButton.setTitle(authType.revertedValue.title, for: .normal)
        authToggleButton.setTitleColor(BaseColor.blue, for: .normal)
        authToggleButton.titleLabel?.font = BaseFont.semibold

        authButton.title = authType.title
    }

    private func setActions() {
        authToggleButton.addTarget(self, action: #selector(authToggleButtonAction), for: .touchUpInside)

        authButton.action = { [weak self] in
            guard let viewController = self,
                  let email = viewController.emailTextView.text,
                  let password = viewController.passwordTextView.text else {
                return
            }

            switch viewController.authType {
            case .signIn:
                viewController.interactor?.signIn(email: email, password: password)
            case .signUp:
                guard let confirmPassword = viewController.confirmPasswordTextView.text else { return }
                viewController.interactor?.signUp(email: email, password: password, confirmPassword: confirmPassword)
            }
        }
    }

    @objc private func authToggleButtonAction() {
        authType = authType.revertedValue

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let viewController = self else { return }

            viewController.confirmPasswordTextView.alpha = viewController.authType == .signIn ? 0 : 1
            viewController.confirmPasswordTextView.isHidden = viewController.authType == .signIn
            viewController.stackView.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let viewController = self else { return }

            viewController.authToggleButton.setTitle(viewController.authType.revertedValue.title, for: .normal)
            viewController.authButton.title = viewController.authType.title
        }
    }
}

extension AuthViewController: AuthViewInput {

    func set(isLoading: Bool) {
        authButton.isLoading = isLoading
    }

    func configureSignIn() {
        authToggleButtonAction()
    }
}
