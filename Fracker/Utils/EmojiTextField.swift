//
//  EmojiTextField.swift
//  Fracker
//
//  Created by Yesset Murat on 4/30/22.
//

import UIKit

class EmojiTextField: UITextField {

    override var textInputContextIdentifier: String? { "" }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
