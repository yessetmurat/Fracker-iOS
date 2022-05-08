//
//  CategoryShimmerCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import BaseKit

class CategoryShimmerCell: UICollectionViewCell {

    let view = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(view)
        view.layout(over: contentView, left: 4, top: 10, right: 10, bottom: 10)
        stylize()
    }

    private func stylize() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
