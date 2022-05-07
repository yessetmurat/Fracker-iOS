//
//  AnalyticsChartShimmerView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsChartShimmerView: UIView {

    private let chartShimmerView = ShimmerView()
    private let selectorShimmerView = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(chartShimmerView)
        addSubview(selectorShimmerView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        chartShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            chartShimmerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            chartShimmerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            chartShimmerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            chartShimmerView.heightAnchor.constraint(equalToConstant: 180)
        ]

        selectorShimmerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectorShimmerView.topAnchor.constraint(equalTo: chartShimmerView.bottomAnchor, constant: 16),
            selectorShimmerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            selectorShimmerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            selectorShimmerView.widthAnchor.constraint(equalToConstant: 205),
            selectorShimmerView.heightAnchor.constraint(equalToConstant: 42)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        chartShimmerView.layer.cornerRadius = 4
        chartShimmerView.clipsToBounds = true

        selectorShimmerView.layer.cornerRadius = 4
        selectorShimmerView.clipsToBounds = true
    }

    func startAnimating() {
        chartShimmerView.startAnimating()
        selectorShimmerView.startAnimating()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsChartShimmerView: ResettableView {

    func reset() {}
}
