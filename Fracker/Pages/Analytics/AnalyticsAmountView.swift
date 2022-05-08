//
//  AnalyticsAmountView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsAmountView: UIView {

    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let percentStackView = UIStackView()
    private let imageView = UIImageView()
    private let percentLabel = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var descriptionString: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    var didRise: Bool? {
        didSet {
            guard let didRise = didRise else {
                imageView.image = BaseImage.minus.uiImage
                percentLabel.textColor = BaseColor.blue
                return
            }
            imageView.image = didRise ? BaseImage.arrowUp.uiImage : BaseImage.arrowDown.uiImage
            percentLabel.textColor = didRise ? BaseColor.red : BaseColor.green
        }
    }

    var percent: String? {
        get { percentLabel.text }
        set { percentLabel.text = newValue }
    }

    var isLoading = false {
        didSet {
            isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(percentStackView)
        percentStackView.addArrangedSubview(imageView)
        percentStackView.addArrangedSubview(percentLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += horizontalStackView.getLayoutConstraints(over: self, margin: 8)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 32)]

        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [descriptionStackView.heightAnchor.constraint(equalToConstant: 22)]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [imageView.widthAnchor.constraint(equalToConstant: 16)]

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [activityIndicatorView.widthAnchor.constraint(equalToConstant: 32)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = BaseColor.white

        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading

        titleLabel.font = BaseFont.semibold.withSize(32)
        titleLabel.textColor = BaseColor.black

        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 8

        descriptionLabel.font = BaseFont.semibold.withSize(14)
        descriptionLabel.textColor = BaseColor.gray

        percentStackView.axis = .horizontal
        percentStackView.spacing = 4

        imageView.image = BaseImage.arrowDown.uiImage
        imageView.contentMode = .scaleAspectFit

        percentLabel.font = BaseFont.semibold.withSize(14)
        percentLabel.textColor = BaseColor.green

        activityIndicatorView.color = BaseColor.blue
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsAmountView: ResettableView {

    func reset() {
        title = nil
        descriptionString = nil
        didRise = nil
        percent = nil
        isLoading = false
    }
}
