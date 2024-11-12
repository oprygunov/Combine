//
//  MainView.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import UIKit

final class MainView: View {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>

    private typealias ProductCellRegistration = UICollectionView.CellRegistration<ProductViewCell, ProductContentView.Model>
    private typealias TypeCellRegistration = UICollectionView.CellRegistration<TypeViewCell, TypeContentView.Model>
    private typealias AdditionalCellRegistration = UICollectionView.CellRegistration<AdditionalViewCell, AdditionalContentView.Model>
    private typealias InstructionsCellRegistration = UICollectionView.CellRegistration<InstructionsViewCell, InstructionsContentView.Model>

    enum Action {
        case close
        case decrease
        case increase
        case selectedType(Int)
        case selectedAdditional(Int)
        case comment(String)
        case add
        case basket
    }
    var actionHandler: (Action) -> Void = { _ in }

    var viewModel: Main.RootViewModel? {
        didSet {
            guard let viewModel else { return }
            basketView.viewModel = .init(total: viewModel.total)
            addButton.title = viewModel.addToBasket

            let typeHeader: HeaderContentView.Model = .init(title: "Type", showRequired: true)
            let typeFooter: FooterContentView.Model = .init(showSeparator: true)
            let additionalHeader: HeaderContentView.Model = .init(title: "Additional", showRequired: false)
            let additionalFooter: FooterContentView.Model = .init(showSeparator: true)
            let instructionsHeader: HeaderContentView.Model = .init(title: "Instructions", showRequired: false)
            let instructionsFooter: FooterContentView.Model = .init(showSeparator: false)

            var snapshot = Snapshot()
            let sections: [SectionItem] = [
                .product,
                .type(typeHeader, typeFooter),
                .additional(additionalHeader, additionalFooter),
                .instructions(instructionsHeader, instructionsFooter)
            ]

            snapshot.appendSections(sections)
            snapshot.appendItems(
                [
                    .product(
                        .init(
                            identifier: viewModel.product.identifier,
                            image: viewModel.product.image,
                            name: viewModel.product.name,
                            description: viewModel.product.description,
                            price: viewModel.product.price,
                            amount: viewModel.product.amount
                        )
                    )
                ],
                toSection: .product
            )
            snapshot.appendItems(
                viewModel.type.map { item in
                    return .type(
                        .init(title: item.name, isSelected: item.isSelected)
                    )
                },
                toSection: .type(typeHeader, typeFooter)
            )
            snapshot.appendItems(
                viewModel.additional.map { item in
                    return .additional(
                        .init(title: item.name, price: item.price, isSelected: item.isSelected)
                    )
                },
                toSection: .additional(additionalHeader, additionalFooter)
            )
            snapshot.appendItems(
                [
                    .instructions(.init(text: viewModel.instructions))
                ],
                toSection: .instructions(instructionsHeader, instructionsFooter)
            )

            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private enum SectionItem: Hashable {
        case product
        case type(
            HeaderContentView.Model,
            FooterContentView.Model
        )
        case additional(
            HeaderContentView.Model,
            FooterContentView.Model
        )
        case instructions(
            HeaderContentView.Model,
            FooterContentView.Model
        )
    }

    private enum CellItem: Hashable {
        case product(ProductContentView.Model)
        case type(TypeContentView.Model)
        case additional(AdditionalContentView.Model)
        case instructions(InstructionsContentView.Model)
    }

    private var bottomConstraint: NSLayoutConstraint?

    private lazy var backButton: BackButton = {
        let view = BackButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] in
            self?.actionHandler(.close)
        }
        return view
    }()

    private lazy var basketView: BasketButton = {
        let view = BasketButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] in
            self?.actionHandler(.basket)
        }
        return view
    }()

    private lazy var addButton: AddButton = {
        let view = AddButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] in
            self?.actionHandler(.add)
        }
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "obackground")
        return view
    }()

    private lazy var backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blur = CustomVisualEffectView(effect: blurEffect, intensity: 1.0)
        return blur
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        view.alwaysBounceVertical = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        return view
    }()

    private lazy var dataSource: DataSource = {
        let productCellRegistration = ProductCellRegistration { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] action in
                switch action {
                case .minus:
                    self?.actionHandler(.decrease)
                case .plus:
                    self?.actionHandler(.increase)
                }
            }
        }

        let typeCellRegistration = TypeCellRegistration { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] action in
                switch action {
                case .enable:
                    self?.actionHandler(.selectedType(indexPath.row))
                }
            }
        }

        let additionalCellRegistration = AdditionalCellRegistration { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] action in
                switch action {
                case .enable:
                    self?.actionHandler(.selectedAdditional(indexPath.row))
                }
            }
        }

        let instructionsCellRegistration = InstructionsCellRegistration { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] action in
                switch action {
                case .text(let text):
                    self?.actionHandler(.comment(text))
                }
            }
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: "Header") { [weak self] (view, string, indexPath) in
            guard let header = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch header {
            case .product:
                break
            case .type(let viewModel, _):
                view.viewModel = viewModel
            case .additional(let viewModel, _):
                view.viewModel = viewModel
            case .instructions(let viewModel, _):
                view.viewModel = viewModel
            }
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<FooterView>(elementKind: "Footer") { [weak self] (view, string, indexPath) in
            guard let footer = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch footer {
            case .product:
                break
            case .type(_, let viewModel):
                view.viewModel = viewModel
            case .additional(_, let viewModel):
                view.viewModel = viewModel
            case .instructions(_, let viewModel):
                view.viewModel = viewModel
            }
        }

        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .product(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(using: productCellRegistration, for: indexPath, item: viewModel)
            case .type(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(using: typeCellRegistration, for: indexPath, item: viewModel)
            case .additional(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(using: additionalCellRegistration, for: indexPath, item: viewModel)
            case .instructions(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(using: instructionsCellRegistration, for: indexPath, item: viewModel)
            }
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            if kind == "Header" {
                return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }
            else {
                return view.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
            }
        }
        return dataSource
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let view = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.cancelsTouchesInView = false
        return view
    }()

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            var scrollViewContentOffset = self.collectionView.contentOffset
            scrollViewContentOffset.y += keyboardHeight
            self.collectionView.setContentOffset(scrollViewContentOffset, animated: false)
            self.bottomConstraint?.constant = -keyboardHeight
            self.containerView.layoutSubviews()

        })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            var scrollViewContentOffset = self.collectionView.contentOffset
            scrollViewContentOffset.y -= keyboardHeight
            self.collectionView.setContentOffset(scrollViewContentOffset, animated: false)
            self.bottomConstraint?.constant = 0
            self.containerView.layoutSubviews()
        })
    }

    @objc func dismissKeyboard (sender: UITapGestureRecognizer) {
        endEditing(true)
    }

    override func setupContent() {
        super.setupContent()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UITextView.keyboardWillHideNotification, object: nil)

        addSubview(imageView)
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(addButton)

        addSubview(backButton)
        addSubview(basketView)

        addGestureRecognizer(tapGesture)
    }

    override func setupLayout() {
        super.setupLayout()
        containerView.pinToSuperview(excluding: [.bottom])

        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint?.isActive = true

        backgroundView.pinToSuperview()

        imageView.pinToSuperview()

        collectionView.topAnchor ~= containerView.topAnchor
        collectionView.leftAnchor ~= containerView.leftAnchor
        collectionView.rightAnchor ~= containerView.rightAnchor
        collectionView.bottomAnchor ~= containerView.bottomAnchor

        backButton.topAnchor ~= safeAreaLayoutGuide.topAnchor + 5
        backButton.leftAnchor ~= leftAnchor + 20

        basketView.topAnchor ~= safeAreaLayoutGuide.topAnchor + 5
        basketView.rightAnchor ~= rightAnchor - 20

        addButton.leftAnchor ~= containerView.leftAnchor + 20
        addButton.rightAnchor ~= containerView.rightAnchor - 20
        addButton.bottomAnchor <= containerView.bottomAnchor - 20
        let bottom = addButton.bottomAnchor ~= safeAreaLayoutGuide.bottomAnchor
        bottom.priority = .defaultHigh
    }
}

extension MainView {
    func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment  in
            guard let self, let identifier = self.dataSource.snapshot().sectionIdentifiers[safe: sectionIndex] else {
                return self?.createSectionLayout(heightDimension: .estimated(31))
            }
            switch identifier {
            case .product:
                return createSectionLayout(heightDimension: .estimated(500))
            case .type:
                return createSectionLayout(heightDimension: .estimated(24.0), enableBlock: true)
            case .additional:
                return createSectionLayout(heightDimension: .estimated(26.0), enableBlock: true)
            case .instructions:
                return createSectionLayout(heightDimension: .estimated(100.0), enableBlock: true)
            }
        }
        return layout
    }

    func createSectionLayout(heightDimension: NSCollectionLayoutDimension, enableBlock: Bool = false) -> NSCollectionLayoutSection {
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )

        // Footer
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(41.0)
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: "Footer",
            alignment: .bottom
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: heightDimension
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        if enableBlock {
            section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        }
        return section
    }
}
