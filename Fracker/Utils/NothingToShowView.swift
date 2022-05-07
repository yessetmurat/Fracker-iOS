//
//  NothingToShowView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import UIKit
import BaseKit

class NothingToShowView: UIView {

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraintsByCentering(over: self)
        layoutConstraints += [
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24)
        ]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center

        imageView.image = BaseImage.sad.uiImage(tintColor: BaseColor.gray)
        imageView.contentMode = .scaleAspectFit

        titleLabel.text = "Nothing to show. Try again later..."
        titleLabel.textColor = BaseColor.gray
        titleLabel.font = BaseFont.semibold.withSize(20)
        titleLabel.numberOfLines = 0
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
