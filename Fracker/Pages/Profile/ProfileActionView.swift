//
//  ProfileActionView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import UIKit
import BaseKit

class ProfileActionView: UIView {

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let accessoryImageView = UIImageView()

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var accessoryImage: UIImage? {
        get { accessoryImageView.image }
        set { accessoryImageView.image = newValue }
    }

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
        stackView.addArrangedSubview(accessoryImageView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: self, margin: 8)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ]

        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            accessoryImageView.widthAnchor.constraint(equalToConstant: 24),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        stackView.spacing = 12

        imageView.contentMode = .scaleAspectFit

        titleLabel.font = BaseFont.semibold
        titleLabel.textColor = BaseColor.black

        accessoryImageView.contentMode = .scaleAspectFit
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ProfileActionView: ResettableView {

    func reset() {
        image = nil
        title = nil
        accessoryImage = nil
    }
}
