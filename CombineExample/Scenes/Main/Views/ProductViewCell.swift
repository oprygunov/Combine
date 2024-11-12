//
//  ProductView.swift
//  
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class ProductViewCell: UICollectionViewCell {
    var viewModel: ProductContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    var actionHandler: (ProductContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }

    private lazy var cellContentView: ProductContentView = {
        let view = ProductContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class ProductContentView: View {
    enum Action {
        case minus
        case plus
    }

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var identifier: String?
        var image: String?
        var name: String?
        var description: String?
        var price: String?
        var amount: String?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            imageView.image = UIImage(named: viewModel.image ?? "")
            informationView.viewModel = .init(
                name: viewModel.name,
                description: viewModel.description,
                price: viewModel.price,
                amount: viewModel.amount
            )
        }
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    private lazy var informationView: ProductInformationView =  {
        let view = ProductInformationView()
        view.actionHandler = { [weak self] action in
            switch action {
            case .minus:
                self?.actionHandler(.minus)
            case .plus:
                self?.actionHandler(.plus)
            }
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: SeparatorView =  {
        let view = SeparatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(containerImageView)
        addSubview(imageView)
        addSubview(informationView)
        addSubview(separatorView)
    }

    override func setupLayout() {
        super.setupLayout()
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        let topInset = keyWindow?.safeAreaInsets.top ?? 0

        containerImageView.pinToSuperview(excluding: [.bottom])

        imageView.topAnchor ~= containerImageView.topAnchor + topInset
        imageView.leftAnchor ~= containerImageView.leftAnchor
        imageView.rightAnchor ~= containerImageView.rightAnchor
        imageView.bottomAnchor ~= containerImageView.bottomAnchor
        imageView.heightAnchor ~= 340

        informationView.pinToSuperview(excluding: [.top, .bottom])
        informationView.topAnchor ~= containerImageView.bottomAnchor - 91

        separatorView.pinToSuperview(excluding: [.top])
        separatorView.topAnchor ~= informationView.bottomAnchor
    }
}

class ProductInformationView: View {
    enum Action {
        case minus
        case plus
    }

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var name: String?
        var description: String?
        var price: String?
        var amount: String?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.name
            priceLabel.text = viewModel.price
            descriptionLabel.text = viewModel.description
            amountView.viewModel = .init(amount: viewModel.amount)
        }
    }

    private let containerView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        return view
    }()

    private let topView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let topGradientView: CAGradientLayer = {
        let view = CAGradientLayer()
        view.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 43/255, green: 42/255, blue: 109/255, alpha: 1.0).cgColor
        ]
        view.startPoint = CGPoint(x: 0, y: 0)
        view.endPoint = CGPoint(x: 0, y: 1)
        return view
    }()

    private let bottomGradientView: CAGradientLayer = {
        let view = CAGradientLayer()
        view.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        view.startPoint = CGPoint(x: 0.5, y: 0.2)
        view.endPoint = CGPoint(x: 1, y: 0.7)
        return view
    }()

    private let bottomView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var amountView: AmountView =  {
        let view = AmountView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            switch action {
            case .minus:
                self?.actionHandler(.minus)
            case .plus:
                self?.actionHandler(.plus)
            }
        }
        return view
    }()

    private let titleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()

    private let priceLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()

    private let descriptionLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .lightGray
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientView.frame = topView.bounds
        bottomGradientView.frame = backgroundView.bounds
    }

    override func setupContent() {
        super.setupContent()
        topView.layer.addSublayer(topGradientView)
        backgroundView.layer.addSublayer(bottomGradientView)
        addSubview(backgroundView)
        addSubview(containerView)

        addSubview(topView)
        addSubview(bottomView)

        addSubview(titleLabel)
        addSubview(priceLabel)

        addSubview(amountView)

        bottomView.addSubview(descriptionLabel)
    }

    override func setupLayout() {
        super.setupLayout()
        containerView.pinToSuperview(left: 20, right: 20, bottom: 20)
        backgroundView.pinToSuperview(top: 91)

        topView.topAnchor ~= containerView.topAnchor
        topView.leftAnchor ~= containerView.leftAnchor
        topView.rightAnchor ~= containerView.rightAnchor

        bottomView.topAnchor ~= topView.bottomAnchor
        bottomView.leftAnchor ~= containerView.leftAnchor
        bottomView.rightAnchor ~= containerView.rightAnchor
        bottomView.bottomAnchor ~= containerView.bottomAnchor

        titleLabel.topAnchor ~= topView.topAnchor + 20
        titleLabel.leftAnchor ~= topView.leftAnchor + 20
        titleLabel.rightAnchor ~= topView.rightAnchor - 20

        priceLabel.topAnchor ~= titleLabel.bottomAnchor + 3
        priceLabel.leftAnchor ~= topView.leftAnchor + 20
        priceLabel.rightAnchor ~= topView.rightAnchor - 20
        priceLabel.bottomAnchor ~= topView.bottomAnchor - 20

        descriptionLabel.topAnchor ~= bottomView.topAnchor + 20
        descriptionLabel.leftAnchor ~= bottomView.leftAnchor + 20
        descriptionLabel.rightAnchor ~= bottomView.rightAnchor - 20

        amountView.topAnchor ~= descriptionLabel.bottomAnchor + 20
        amountView.leftAnchor ~= bottomView.leftAnchor + 20
        amountView.bottomAnchor ~= bottomView.bottomAnchor - 20
    }
}
