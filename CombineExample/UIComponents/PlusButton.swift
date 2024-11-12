//
//  PlusButton.swift
//  
//
//  Created by Oleg Prygunov on 25.01.2023.
//

import Foundation
import UIKit

public class PlusButton: View {
    public var isSelected: Bool? {
        didSet {
            guard let isSelected else { return }
            if isSelected {
                imageView.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
            }
            else {
                imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
            }
            imageView.tintColor = .white
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

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        addTouchAnimation()
        addSubview(squareView)
        addSubview(imageView)
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

        imageView.bottomAnchor ~= squareView.bottomAnchor - 5
        imageView.topAnchor ~= squareView.topAnchor + 5
        imageView.leftAnchor ~= squareView.leftAnchor + 5
        imageView.rightAnchor ~= squareView.rightAnchor - 5

        control.pinToSuperview()
    }
}
