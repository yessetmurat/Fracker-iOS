//
//  AnalyticsCategoryShimmerView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsCategoryShimmerView: UIView {

    private let stackView = UIStackView()
    private let emojiShimmerView = ShimmerView()
    private let titleStackView = UIStackView()
    private let titleShimmerView = ShimmerView()
    private let descriptionShimmerView = ShimmerView()
    private let amountShimmerView = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(emojiShimmerView)
        stackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(titleShimmerView)
        titleStackView.addArrangedSubview(descriptionShimmerView)
        stackView.addArrangedSubview(amountShimmerView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, margin: 8)
        layoutConstraints += [stackView.heightAnchor.constraint(equalToConstant: 36)]

        emojiShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            emojiShimmerView.widthAnchor.constraint(equalToConstant: 32),
            emojiShimmerView.heightAnchor.constraint(equalToConstant: 32)
        ]

        titleShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleShimmerView.widthAnchor.constraint(equalToConstant: 180),
            titleShimmerView.heightAnchor.constraint(equalToConstant: 16)
        ]

        descriptionShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionShimmerView.widthAnchor.constraint(equalToConstant: 100),
            descriptionShimmerView.heightAnchor.constraint(equalToConstant: 12)
        ]

        amountShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountShimmerView.widthAnchor.constraint(equalToConstant: 60),
            amountShimmerView.heightAnchor.constraint(equalToConstant: 16)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center

        titleStackView.axis = .vertical
        titleStackView.spacing = 8
        titleStackView.alignment = .leading

        emojiShimmerView.layer.cornerRadius = 4
        emojiShimmerView.clipsToBounds = true

        titleShimmerView.layer.cornerRadius = 4
        titleShimmerView.clipsToBounds = true

        descriptionShimmerView.layer.cornerRadius = 4
        descriptionShimmerView.clipsToBounds = true

        amountShimmerView.layer.cornerRadius = 4
        amountShimmerView.clipsToBounds = true
    }

    func startAnimating() {
        emojiShimmerView.startAnimating()
        titleShimmerView.startAnimating()
        descriptionShimmerView.startAnimating()
        amountShimmerView.startAnimating()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsCategoryShimmerView: ResettableView {

    func reset() {}
}
