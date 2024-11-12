//
//  InstructionsViewCell.swift
//  
//
//  Created by Oleg Prygunov on 24.01.2023.
//

import Foundation
import UIKit

final class InstructionsViewCell: UICollectionViewCell {
    var viewModel: InstructionsContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }

    var actionHandler: (InstructionsContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }

    private lazy var cellContentView: InstructionsContentView = {
        let view = InstructionsContentView()
        addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

class InstructionsContentView: View {
    enum Action {
        case text(String)
    }

    var actionHandler: (Action) -> Void = { _ in }

    struct Model: Hashable {
        var text: String?
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            textView.text = viewModel.text
        }
    }

    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        view.layer.cornerRadius = 10
        view.delegate = self
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(textView)
    }

    override func setupLayout() {
        super.setupLayout()
        textView.pinToSuperview(left: 20, top: 10, right: 20, bottom: 10)
    }
}

extension InstructionsContentView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        actionHandler(.text(textView.text))
    }
}
