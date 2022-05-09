//
//  LabelView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import UIKit
import BaseKit

class LabelView: UIView {

    private let titleLabel = UILabel()

    var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.layout(over: self, margin: 8)
        stylize()
    }

    private func stylize() {
        titleLabel.font = BaseFont.semibold.withSize(12)
        titleLabel.textColor = BaseColor.gray
        titleLabel.numberOfLines = 0
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension LabelView: ResettableView {

    func reset() {
        text = nil
    }
}
