//
//  ChartCell.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class ChartCell: UICollectionViewCell {

    private let view = UIView()
    private let label = UILabel()

    private lazy var viewHeightConstraint = view.heightAnchor.constraint(equalToConstant: 0)

    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var value: Float = 0 {
        didSet {
            guard 0...1 ~= value else { return }
            viewHeightConstraint.constant = 122 * CGFloat(value)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        title = nil
        value = 0
    }

    private func addSubviews() {
        contentView.addSubview(view)
        contentView.addSubview(label)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        view.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            view.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            view.widthAnchor.constraint(equalToConstant: 16),
            viewHeightConstraint
        ]

        label.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: 16),
            label.heightAnchor.constraint(equalToConstant: 16)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.blue
        view.layer.cornerRadius = 3
        view.clipsToBounds = true

        label.font = BaseFont.semibold.withSize(12)
        label.textAlignment = .center
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
