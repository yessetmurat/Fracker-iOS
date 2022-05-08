//
//  ProfileView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import UIKit
import BaseKit

class ProfileView: UIView {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var descriptionString: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, margin: 8)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 34)]

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [descriptionLabel.heightAnchor.constraint(equalToConstant: 22)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.axis = .vertical
        stackView.spacing = 2

        titleLabel.font = BaseFont.semibold.withSize(32)
        titleLabel.textColor = BaseColor.black

        descriptionLabel.font = BaseFont.semibold
        descriptionLabel.textColor = BaseColor.blue
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ProfileView: ResettableView {

    func reset() {
        title = nil
        descriptionString = nil
    }
}
