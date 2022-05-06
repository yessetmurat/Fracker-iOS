//
//  ShakableView.swift
//  Fracker
//
//  Created by Yesset Murat on 4/25/22.
//

import UIKit
import BaseKit

protocol ShakableView {

    var viewToShake: UIView? { get }
}

extension ShakableView {

    var viewToShake: UIView? { nil }

    func shake() {
        guard let view = viewToShake else { return }
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 4, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 4, y: view.center.y))
        view.layer.add(animation, forKey: "shake")

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

