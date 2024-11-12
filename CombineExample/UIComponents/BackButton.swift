//
//  BackButton.swift
//
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

public class BackButton: View {
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

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "chevron.left")
        image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.image = image
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        backgroundColor = .black
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        addTouchAnimation()

        addSubview(imageView)
        addSubview(control)
    }

    public override func setupLayout() {
        super.setupLayout()
        heightAnchor ~= 44
        widthAnchor ~= 44

        imageView.centerYAnchor ~= centerYAnchor
        imageView.centerXAnchor ~= centerXAnchor

        control.pinToSuperview()
    }
}
