//
//  CategoryTextFieldCell.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

protocol CategoryTextFieldDelegate: AnyObject {

    func textFieldDidEndEditing(withEmoji emoji: String, text: String)
}

class CategoryTextFieldCell: UICollectionViewCell {

    private let containerView = UIView()
    private let stackView = UIStackView()
    private let emojiTextField = EmojiTextField()
    private let textField = UITextField()

    weak var delegate: CategoryTextFieldDelegate?

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
        emojiTextField.text = nil
        emojiTextField.resignFirstResponder()
        textField.text = nil
        textField.resignFirstResponder()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(emojiTextField)
        stackView.addArrangedSubview(textField)
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

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: containerView, left: 12, right: 12)

        emojiTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [emojiTextField.widthAnchor.constraint(equalToConstant: 24)]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        containerView.backgroundColor = BaseColor.lightGray
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        stackView.axis = .horizontal

        emojiTextField.font = BaseFont.semibold.withSize(14)
        emojiTextField.textColor = BaseColor.black

        textField.font = BaseFont.semibold.withSize(14)
        textField.placeholder = "Enter name..."
        textField.returnKeyType = .done
        textField.textColor = BaseColor.black
    }

    private func setActions() {
        emojiTextField.delegate = self
        textField.delegate = self
    }

    func startEditing() {
        DispatchQueue.main.async {
            self.emojiTextField.becomeFirstResponder()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CategoryTextFieldCell: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let text = textField.text ?? ""
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)

        if textField == emojiTextField, updatedText.count == 1 {
            textField.text = updatedText
            DispatchQueue.main.async { self.textField.becomeFirstResponder() }
            return false
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = delegate,
              let emoji = emojiTextField.text,
              let text = self.textField.text,
              !emoji.isEmpty,
              !text.isEmpty else {
            return
        }
        delegate.textFieldDidEndEditing(withEmoji: emoji, text: text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        return false
    }
}
