//
//  SeparatorView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class SeparatorView: UIView {

    private let view = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(view)
        setLayoutConstraints()
        stylize()
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        view.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += view.getLayoutConstraints(over: self, margin: 8)
        layoutConstraints += [view.heightAnchor.constraint(equalToConstant: 2)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.lightGray
        view.layer.cornerRadius = 1
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension SeparatorView: ResettableView {

    func reset() {}
}
