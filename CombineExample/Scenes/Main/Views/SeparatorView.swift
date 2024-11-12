//
//  SeparatorView.swift
//
//
//  Created by Oleg Prygunov on 24.01.2023.
//
import UIKit

class SeparatorView: View {
    private let containerView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let gradientView: CAGradientLayer = {
        let view = CAGradientLayer()
        view.colors = [
            UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor,
            UIColor(red: 103/255, green: 102/255, blue: 169/255, alpha: 1.0).cgColor,
            UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        ]
        view.startPoint = CGPoint(x: 0.0, y: 0.5)
        view.endPoint = CGPoint(x: 1.0, y: 0.5)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = containerView.bounds
    }

    override func setupContent() {
        super.setupContent()
        containerView.layer.addSublayer(gradientView)
        addSubview(containerView)
    }

    override func setupLayout() {
        super.setupLayout()
        containerView.pinToSuperview()
        containerView.heightAnchor ~= 1
    }
}
