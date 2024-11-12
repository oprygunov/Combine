//
//  CheckboxButton.swift
//
//
//  Created by Oleg Prygunov on 25.01.2023.
//

import UIKit

public class CheckboxButton: View {
    public var isSelected: Bool? {
        didSet {
            selectedView.isHidden = !(isSelected ?? false)
        }
    }

    public var actionHandler: () -> Void = {}

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

    private let squareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        return view
    }()

    private let selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0)
        view.layer.cornerRadius = 4
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        addTouchAnimation()

        addSubview(squareView)
        addSubview(selectedView)
        addSubview(control)
    }

    public override func setupLayout() {
        super.setupLayout()
        heightAnchor ~= 44
        widthAnchor ~= 44

        squareView.centerYAnchor ~= centerYAnchor
        squareView.centerXAnchor ~= centerXAnchor
        squareView.heightAnchor ~= 28
        squareView.widthAnchor ~= 28

        selectedView.centerYAnchor ~= centerYAnchor
        selectedView.centerXAnchor ~= centerXAnchor
        selectedView.heightAnchor ~= 14
        selectedView.widthAnchor ~= 14

        control.pinToSuperview()
    }
}
