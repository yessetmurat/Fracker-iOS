//
//  CategoryAddCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import BaseKit

class CategoryAddCell: UICollectionViewCell {

    private let containerView = UIView()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += containerView.getLayoutConstraints(
            over: contentView,
            left: 4,
            top: 10,
            right: 10,
            bottom: 10
        )

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += imageView.getLayoutConstraints(over: containerView)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        containerView.backgroundColor = BaseColor.lightGray
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        imageView.image = BaseImage.plus.uiImage
        imageView.contentMode = .center
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
