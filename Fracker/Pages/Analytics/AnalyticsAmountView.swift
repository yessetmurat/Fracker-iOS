//
//  AnalyticsAmountView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsAmountView: UIView {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let percentStackView = UIStackView()
    private let imageView = UIImageView()
    private let percentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(percentStackView)
        percentStackView.addArrangedSubview(imageView)
        percentStackView.addArrangedSubview(percentLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, margin: 8)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 32)]

        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [descriptionStackView.heightAnchor.constraint(equalToConstant: 22)]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [imageView.widthAnchor.constraint(equalToConstant: 16)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = BaseColor.white

        stackView.axis = .vertical
        stackView.alignment = .leading

        titleLabel.text = "70 000₸"
        titleLabel.font = BaseFont.semibold.withSize(32)
        titleLabel.textColor = BaseColor.black

        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 8

        descriptionLabel.text = "Total spent whis week"
        descriptionLabel.font = BaseFont.semibold.withSize(14)
        descriptionLabel.textColor = BaseColor.gray

        percentStackView.axis = .horizontal
        percentStackView.spacing = 4

        imageView.image = BaseImage.arrowDown.uiImage
        imageView.contentMode = .scaleAspectFit

        percentLabel.text = "5%"
        percentLabel.font = BaseFont.semibold.withSize(14)
        percentLabel.textColor = BaseColor.green
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsAmountView: ResettableView {

    func reset() {

    }
}
