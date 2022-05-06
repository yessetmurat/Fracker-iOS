//
//  SelectorCell.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class SelectorCell: UICollectionViewCell {

    private let titleLabel = UILabel()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    override var isSelected: Bool {
        didSet { animate() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        titleLabel.layout(over: contentView)
        stylize()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        isSelected = false
    }

    private func stylize() {
        titleLabel.font = BaseFont.semibold
        titleLabel.textColor = BaseColor.black
        titleLabel.textAlignment = .center

        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 2
        contentView.clipsToBounds = true
    }

    private func animate() {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = isSelected ? UIColor.clear.cgColor : BaseColor.lightGray.cgColor
        animation.toValue = isSelected ? BaseColor.lightGray.cgColor : UIColor.clear.cgColor
        animation.duration = 0.3

        contentView.layer.add(animation, forKey: "borderColor")
        contentView.layer.borderColor = isSelected ? BaseColor.lightGray.cgColor : UIColor.clear.cgColor
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
