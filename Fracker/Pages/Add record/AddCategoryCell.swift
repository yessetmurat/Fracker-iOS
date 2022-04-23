//
//  AddCategoryCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

class AddCategoryCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.layout(over: contentView)
        stylize()
    }

    private func stylize() {
        contentView.backgroundColor = BaseColor.lightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        imageView.image = BaseImage.plus.uiImage
        imageView.contentMode = .center
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
