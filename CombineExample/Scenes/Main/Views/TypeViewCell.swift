//
//  TypeViewCell.swift
//
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class TypeViewCell: UICollectionViewCell {
    var viewModel: TypeContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    var actionHandler: (TypeContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }

    private lazy var cellContentView: TypeContentView = {
        let view = TypeContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class TypeContentView: View {
    enum Action {
        case enable
    }

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var title: String?
        var isSelected: Bool?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.title
            checkboxView.isSelected = viewModel.isSelected
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

    private lazy var checkboxView: CheckboxButton =  {
        let view = CheckboxButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] in
            self?.actionHandler(.enable)
        }
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(titleLabel)
        addSubview(checkboxView)
    }

    override func setupLayout() {
        super.setupLayout()
        titleLabel.pinToSuperview(left: 30, top: 12, right: 50, bottom: 12)

        checkboxView.centerYAnchor ~= centerYAnchor
        checkboxView.rightAnchor ~= rightAnchor - 12
    }
}
