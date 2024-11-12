//
//  FooterView.swift
//  
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class FooterView: UICollectionReusableView {
    var viewModel: FooterContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    private lazy var cellContentView: FooterContentView = {
        let view = FooterContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class FooterContentView: View {
    struct Model: Hashable {
        var showSeparator: Bool?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            separatorView.isHidden = !(viewModel.showSeparator ?? false)
        }
    }

    private let separatorView: SeparatorView =  {
        let view = SeparatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(separatorView)
    }

    override func setupLayout() {
        super.setupLayout()
        separatorView.pinToSuperview(top: 20, bottom: 20)
    }
}
