//
//  UIConstants.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit

class UIConstants {

    class var invisibleViewFrame: CGRect {
        return .init(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude)
    }
}
