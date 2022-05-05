//
//  CategoryCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

protocol CategoryCellDelegate: AnyObject {

    func categoryCell(didTapOnRemoveAtIndexPath indexPath: IndexPath)
}

class CategoryCell: UICollectionViewCell {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)

    weak var delegate: CategoryCellDelegate?
    var indexPath: IndexPath?

    override var isSelected: Bool {
        didSet {
            guard !isRemoving else { return }
            setSelected(isSelected)
        }
    }

    var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var isRemoving = false {
        didSet {
            removeButton.isHidden = !isRemoving
            isRemoving ? startShaking() : stopShaking()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
        indexPath = nil
        text = nil
        isRemoving = false
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        contentView.addSubview(removeButton)
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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += titleLabel.getLayoutConstraints(over: containerView)

        removeButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            removeButton.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            removeButton.centerXAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        containerView.backgroundColor = BaseColor.lightGray
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        titleLabel.font = BaseFont.semibold.withSize(14)
        titleLabel.textColor = BaseColor.black
        titleLabel.textAlignment = .center

        let removeImage = BaseImage.close.uiImage?
            .fitThenCenter(in: CGSize(width: 16, height: 16))

        removeButton.backgroundColor = BaseColor.red
        removeButton.setImage(removeImage, for: .normal)
        removeButton.tintColor = BaseColor.white
        removeButton.layer.cornerRadius = 12
        removeButton.clipsToBounds = true
    }

    private func setActions() {
        removeButton.addTarget(self, action: #selector(removeButtonAction), for: .touchUpInside)
    }

    private func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let view = self else { return }

            view.containerView.backgroundColor = isSelected ? BaseColor.blue : BaseColor.lightGray
            view.titleLabel.textColor = isSelected ? BaseColor.white : BaseColor.black
        }
    }

    private func startShaking() {
        let startAngle: Double = -2 * .pi / 180
        let stopAngle = -startAngle
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = NSNumber(value: startAngle)
        animation.toValue = NSNumber(value: 1.5 * stopAngle)
        animation.autoreverses = true
        animation.duration = 0.16
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        layer.add(animation, forKey: "shake")
    }

    private func stopShaking() {
        layer.removeAnimation(forKey: "shake")
    }

    @objc private func removeButtonAction() {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        delegate.categoryCell(didTapOnRemoveAtIndexPath: indexPath)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
