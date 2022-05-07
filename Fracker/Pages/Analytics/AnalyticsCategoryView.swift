//
//  AnalyticsCategoryView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsCategoryView: UIView {

    private let horizontalStackView = UIStackView()
    private let emojiLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let amountLabel = UILabel()

    var emoji: String? {
        get { emojiLabel.text }
        set { emojiLabel.text = newValue }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var descriptionString: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    var amount: String? {
        get { amountLabel.text }
        set { amountLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(emojiLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(amountLabel)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += horizontalStackView.getLayoutConstraints(over: self, margin: 8)

        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [emojiLabel.widthAnchor.constraint(equalToConstant: 32)]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 18)]

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [descriptionLabel.heightAnchor.constraint(equalToConstant: 14)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.distribution = .fill

        emojiLabel.font = BaseFont.semibold.withSize(24)

        verticalStackView.axis = .vertical
        verticalStackView.spacing = 2

        titleLabel.font = BaseFont.semibold
        titleLabel.textColor = BaseColor.black

        descriptionLabel.font = BaseFont.semibold.withSize(12)
        descriptionLabel.textColor = BaseColor.gray

        amountLabel.font = BaseFont.semibold
        amountLabel.textColor = BaseColor.black
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsCategoryView: ResettableView {

    func reset() {
        emoji = nil
        title = nil
        descriptionString = nil
        amount = nil
    }
}
