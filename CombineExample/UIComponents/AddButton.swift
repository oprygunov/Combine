//
//  AddButton.swift
//
//
//  Created by Oleg Prygunov on 25.01.2023.
//

import UIKit

public class AddButton: View {
    public var title: String? {
        didSet {
            guard let title else { return }
            titleLabel.text = title
        }
    }

    public var actionHandler: () -> Void = {}

    private let titleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return view
    }()

    private lazy var backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blur = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        blur.tintColor = UIColor(red: 15/255, green: 85/255, blue: 232/255, alpha: 1.0)
        return blur
    }()

    private lazy var control: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandler()
                }
            ),
            for: .touchUpInside
        )
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        addTouchAnimation()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 15/255, green: 85/255, blue: 232/255, alpha: 1.0).cgColor
        layer.masksToBounds = true
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(control)
    }

    public override func setupLayout() {
        super.setupLayout()
        heightAnchor ~= 44

        backgroundView.pinToSuperview()

        titleLabel.centerXAnchor ~= centerXAnchor
        titleLabel.centerYAnchor ~= centerYAnchor
        titleLabel.leftAnchor <= leftAnchor

        control.pinToSuperview()
    }
}
