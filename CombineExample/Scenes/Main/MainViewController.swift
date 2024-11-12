//
//  MainViewController.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    var presenter: MainPresentable?
    var router: MainRoutingLogic?
    private var cancellables: Set<AnyCancellable> = []

    private lazy var rootView = MainView()

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .close:
                presenter?
                    .close(with: Main.Close.Parameters())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.router?.close()
                    })
                    .store(in: &cancellables)
            case .increase:
                presenter?
                    .increase(with: Main.Increase.Parameters())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .decrease:
                presenter?
                    .decrease(with: Main.Decrease.Parameters())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .selectedType(let index):
                presenter?
                    .selectedType(with: Main.SelectedType.Parameters(index: index))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .selectedAdditional(let index):
                presenter?
                    .selectedAdditional(with: Main.SelectedAdditional.Parameters(index: index))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .comment(let text):
                presenter?
                    .enterComment(with: Main.EnterComment.Parameters(text: text))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .add:
                presenter?
                    .add(with: Main.Add.Parameters())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { error in
                        print(error)
                    }, receiveValue: { [weak self] viewModel in
                        self?.rootView.viewModel = viewModel.root
                    })
                    .store(in: &cancellables)
            case .basket:
                presenter?
                    .basket(with: Main.Basket.Parameters())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] _ in
                        self?.router?.showBasket()
                    })
                    .store(in: &cancellables)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?
            .fetch(with: Main.Fetch.Parameters())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { viewModel in
                self.rootView.viewModel = viewModel.root
            })
            .store(in: &cancellables)
    }
}
