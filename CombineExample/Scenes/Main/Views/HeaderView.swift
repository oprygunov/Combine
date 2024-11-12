//
//  HeaderView.swift
//
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class HeaderView: UICollectionReusableView {
    var viewModel: HeaderContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    var actionHandler: (HeaderContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }

    private lazy var cellContentView: HeaderContentView = {
        let view = HeaderContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class HeaderContentView: View {
    enum Action {}

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var title: String?
        var showRequired: Bool? = false
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.title
        }
    }

    private let titleLabel: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(titleLabel)
    }

    override func setupLayout() {
        super.setupLayout()
        titleLabel.pinToSuperview(left: 20, top: 20, right: 50, bottom: 11)
    }
}
