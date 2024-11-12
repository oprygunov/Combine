//
//  BasketButton.swift
//
//
//  Created by Oleg Prygunov on 25.01.2023.
//

import Foundation
import UIKit

public class BasketButton: View {
    public struct Model: Hashable {
        var total: String?

        public init(total: String? = nil) {
            self.total = total
        }
    }

    public var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.total
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

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "basket")
        image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.image = image
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private let titleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.minimumScaleFactor = 0.7
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
        addSubview(titleLabel)
        addSubview(control)
    }

    public override func setupLayout() {
        super.setupLayout()
        heightAnchor ~= 44

        imageView.centerYAnchor ~= centerYAnchor
        imageView.leftAnchor ~= leftAnchor + 10

        titleLabel.centerYAnchor ~= centerYAnchor
        titleLabel.leftAnchor ~= imageView.rightAnchor + 5
        titleLabel.rightAnchor ~= rightAnchor - 10

        control.pinToSuperview()
    }
}
