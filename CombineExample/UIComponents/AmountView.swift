//
//  AmountView.swift
//
//
//  Created by Oleg Prygunov on 25.01.2023.
//

import Foundation
import UIKit

public class AmountView: View {
    public enum Action {
        case minus
        case plus
    }

    public var actionHandler: (Action) -> Void = { _ in }

    public struct Model: Hashable {
        var amount: String?

        public init(amount: String? = nil) {
            self.amount = amount
        }
    }

    public var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            amountLabel.text = viewModel.amount
        }
    }

    private let amountLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()

    private lazy var plusButton: UIButton =  {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.addTouchAnimation()
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandler(.plus)
                }
            ),
            for: .touchUpInside
        )
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private lazy var minusButton: UIButton =  {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.addTouchAnimation()
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandler(.minus)
                }
            ),
            for: .touchUpInside
        )
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        addSubview(amountLabel)
        addSubview(minusButton)
        addSubview(plusButton)
    }

    public override func setupLayout() {
        super.setupLayout()
        heightAnchor ~= 38
        widthAnchor ~= 100

        minusButton.centerYAnchor ~= centerYAnchor
        minusButton.leftAnchor ~= leftAnchor
        minusButton.heightAnchor ~= 38
        minusButton.widthAnchor ~= 30

        amountLabel.centerYAnchor ~= centerYAnchor
        amountLabel.leftAnchor <= minusButton.rightAnchor + 2
        amountLabel.rightAnchor >= plusButton.leftAnchor - 2

        plusButton.centerYAnchor ~= centerYAnchor
        plusButton.rightAnchor ~= rightAnchor
        plusButton.heightAnchor ~= 38
        plusButton.widthAnchor ~= 30
    }
}

