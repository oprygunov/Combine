//
//  MainPresenter.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import Combine

final class MainPresenter {
    var interactor: MainInteractable

    init(interactor: MainInteractable) {
        self.interactor = interactor
    }
}

// MARK: Implementation of Presenting methods
extension MainPresenter: MainPresentable {
    func fetch(with params:  Main.Fetch.Parameters) -> AnyPublisher<Main.Fetch.ViewModel, Main.AppError> {
        interactor
            .fetch(with: params)
            .map { response in
                return Main.Fetch.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }

    func close(with params: Main.Close.Parameters) -> AnyPublisher<Main.Close.ViewModel, Never> {
        interactor
            .close(with: params)
            .map { response in
                return Main.Close.ViewModel()
            }
            .eraseToAnyPublisher()
    }

    func increase(with params: Main.Increase.Parameters) -> AnyPublisher<Main.Increase.ViewModel, Never> {
        interactor
            .increase(with: params)
            .map { response in
                return Main.Increase.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .eraseToAnyPublisher()
    }

    func decrease(with params: Main.Decrease.Parameters) -> AnyPublisher<Main.Decrease.ViewModel, Never> {
        interactor
            .decrease(with: params)
            .map { response in
                return Main.Decrease.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .eraseToAnyPublisher()
    }

    func selectedType(with params: Main.SelectedType.Parameters) -> AnyPublisher<Main.SelectedType.ViewModel, Never> {
        interactor
            .selectedType(with: params)
            .map { response in
                return Main.SelectedType.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .eraseToAnyPublisher()
    }

    func selectedAdditional(with params: Main.SelectedAdditional.Parameters) -> AnyPublisher<Main.SelectedAdditional.ViewModel, Never> {
        interactor
            .selectedAdditional(with: params)
            .map { response in
                return Main.SelectedAdditional.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .eraseToAnyPublisher()
    }

    func enterComment(with params: Main.EnterComment.Parameters) -> AnyPublisher<Main.EnterComment.ViewModel, Never> {
        interactor
            .enterComment(with: params)
            .map { response in
                return Main.EnterComment.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .eraseToAnyPublisher()
    }

    func add(with params: Main.Add.Parameters) -> AnyPublisher<Main.Add.ViewModel, Main.AppError> {
        interactor
            .add(with: params)
            .map { response in
                return Main.Add.ViewModel(root: response.model?.viewModel() ?? .empty)
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }

    func basket(with params: Main.Basket.Parameters) -> AnyPublisher<Main.Basket.ViewModel, Never> {
        interactor
            .basket(with: params)
            .map { response in
                return Main.Basket.ViewModel()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: Models to ViewModel conversion
private extension Main.Model {
    func viewModel() -> Main.RootViewModel {
        .init(
            product: .init(
                identifier: "\(product.identifier)",
                image: product.image,
                name: product.name,
                description: product.description,
                price: String(format: "$ %.2f", product.price),
                amount: "\(product.amount)"
            ),
            type: type.enumerated().map { index, item in
                return .init(
                    identifier: "\(item.identifier)",
                    name: item.name,
                    isSelected: index == selectedType
                )
            },
            additional: additional.enumerated().map { index, item in
                return .init(
                    identifier: "\(item.identifier)",
                    name: item.name,
                    price: "$\(item.price)",
                    isSelected: selectedAdditionals.contains(index)
                )
            },
            instructions: instructions,
            addToBasket: String(format: "Add to Basket ($%.2f)", current),
            total: String(format: "$ %.2f", total)
        )
    }
}

private extension Main.RootViewModel {
    static var empty: Main.RootViewModel = .init(
        product: .init(
            identifier: "",
            image: "",
            name: "",
            description: "",
            price: "",
            amount: ""
        ),
        type: [],
        additional: [],
        instructions: "",
        addToBasket: "",
        total: ""
    )
}
