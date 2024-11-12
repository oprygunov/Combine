//
//  UIView + TouchAnimation.swift
//
//
//  Created by Oleg Prygunov on 13.06.2022.
//

import UIKit

public extension UIView {
    @discardableResult func addTouchAnimation(delegate: UIGestureRecognizerDelegate? = nil) -> UIGestureRecognizer {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
        longPressRecognizer.minimumPressDuration = 0.03
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.delegate = delegate
        addGestureRecognizer(longPressRecognizer)
        return longPressRecognizer
    }

    @objc private func didTapLongPress(sender: UILongPressGestureRecognizer) {
        let scale = max(
            (bounds.width - 10) / max(bounds.width, 1),
            (bounds.height - 10) / max(bounds.height, 1)
        )
        if sender.state == .began {
            animate(self, to: .init(scaleX: scale, y: scale))
        } else {
            animate(self, to: .identity)
        }
    }

    private func animate(_ view: UIView, to transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut]
        ) {
            view.transform = transform
        }
    }

}
