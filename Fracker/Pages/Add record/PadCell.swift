//
//  PadCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import BaseKit

class PadCell: UICollectionViewCell {

    private let containerView = UIView()
    private let imageView = UIImageView()

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()

        image = nil
        setNormalState()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += containerView.getLayoutConstraints(over: contentView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += imageView.getLayoutConstraintsByCentering(over: containerView)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        containerView.backgroundColor = BaseColor.white
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        imageView.tintColor = BaseColor.black
        imageView.contentMode = .scaleAspectFit
    }
}

extension PadCell: PadCellTappable {

    func setTapState() {
        containerView.backgroundColor = BaseColor.lightGray
        imageView.tintColor = BaseColor.blue
    }

    func setNormalState() {
        containerView.backgroundColor = BaseColor.white
        imageView.tintColor = BaseColor.black
    }
}
