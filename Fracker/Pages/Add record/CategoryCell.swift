//
//  CategoryCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

class CategoryCell: UICollectionViewCell {

    private let titleLabel = UILabel()

    override var isSelected: Bool {
        didSet { setSelected(isSelected) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        titleLabel.layout(over: contentView)
        stylize()
    }

    private func stylize() {
        contentView.backgroundColor = BaseColor.lightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        titleLabel.font = BaseFont.semibold.withSize(14)
        titleLabel.textColor = BaseColor.black
        titleLabel.textAlignment = .center
    }

    private func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let view = self else { return }

            view.contentView.backgroundColor = isSelected ? BaseColor.blue : BaseColor.lightGray
            view.titleLabel.textColor = isSelected ? BaseColor.white : BaseColor.black
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
