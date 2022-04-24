//
//  CategoryTextFieldCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

class CategoryTextFieldCell: UICollectionViewCell {

    private let containerView = UIView()
    private let textField = UITextField()

    weak var delegate: BaseTextViewDelegate?

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
        textField.text = nil
        textField.resignFirstResponder()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(textField)
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

        textField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += textField.getLayoutConstraints(over: containerView, left: 12, right: 12)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        containerView.backgroundColor = BaseColor.lightGray
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        textField.font = BaseFont.semibold.withSize(14)
        textField.placeholder = "Enter name..."
        textField.returnKeyType = .done
        textField.textColor = BaseColor.black
    }

    private func setActions() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    @objc private func textFieldEditingChanged() {
        guard let delegate = delegate else { return }
        delegate.baseTextView(UUID(), didChangeText: textField.text)
    }

    func startEditing() {
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CategoryTextFieldCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = delegate else { return }
        delegate.baseTextView(UUID(), didEndEditingText: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.textField.resignFirstResponder()
        }
        return false
    }
}
