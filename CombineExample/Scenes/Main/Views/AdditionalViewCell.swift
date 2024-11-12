//
//  AdditionalViewCell.swift
//
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class AdditionalViewCell: UICollectionViewCell {
    var viewModel: AdditionalContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    var actionHandler: (AdditionalContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }

    private lazy var cellContentView: AdditionalContentView = {
        let view = AdditionalContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class AdditionalContentView: View {
    enum Action {
        case enable
    }

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var title: String?
        var price: String?
        var isSelected: Bool?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.price
            plusView.isSelected = viewModel.isSelected
        }
    }

    private let titleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return view
    }()

    private let subtitleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()

    private lazy var plusView: PlusButton =  {
        let view = PlusButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] in
            self?.actionHandler(.enable)
        }
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(plusView)
    }

    override func setupLayout() {
        super.setupLayout()
        titleLabel.topAnchor ~= topAnchor + 12
        titleLabel.leftAnchor ~= leftAnchor + 30
        titleLabel.rightAnchor ~= rightAnchor - 50

        subtitleLabel.topAnchor ~= titleLabel.bottomAnchor + 2
        subtitleLabel.leftAnchor ~= leftAnchor + 30
        subtitleLabel.rightAnchor ~= rightAnchor - 50
        subtitleLabel.bottomAnchor ~= bottomAnchor - 12

        plusView.centerYAnchor ~= centerYAnchor
        plusView.rightAnchor ~= rightAnchor - 12
    }
}
