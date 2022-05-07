//
//  AnalyticsAmountShimmerView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsAmountShimmerView: UIView {

    private let stackView = UIStackView()
    private let titleShimmerView = ShimmerView()
    private let descriptionShimmerView = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleShimmerView)
        stackView.addArrangedSubview(descriptionShimmerView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, margin: 8)

        titleShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleShimmerView.widthAnchor.constraint(equalToConstant: 130),
            titleShimmerView.heightAnchor.constraint(equalToConstant: 28)
        ]

        descriptionShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionShimmerView.widthAnchor.constraint(equalToConstant: 195),
            descriptionShimmerView.heightAnchor.constraint(equalToConstant: 18)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8

        titleShimmerView.layer.cornerRadius = 4
        titleShimmerView.clipsToBounds = true

        descriptionShimmerView.layer.cornerRadius = 4
        descriptionShimmerView.clipsToBounds = true
    }

    func startAnimating() {
        titleShimmerView.startAnimating()
        descriptionShimmerView.startAnimating()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsAmountShimmerView: ResettableView {

    func reset() {}
}
