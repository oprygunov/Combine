//
//  MainInteractor.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import Combine
import Foundation

final class MainInteractor {
    private let worker: MainWorkable
    private var lock = NSLock()
    private var model: Main.Model? {
        get {
            lock.lock()
            defer {
                lock.unlock()
            }
            return threadSafeModel
        }
        set {
            lock.lock()
            defer {
                lock.unlock()
            }
            threadSafeModel = newValue
        }
    }
    private var threadSafeModel: Main.Model?

    // MARK: Initialization
    init(worker: MainWorkable) {
        self.worker = worker
    }
}

// MARK: Implementation of Business logic methods
extension MainInteractor: MainInteractable{
    func fetch(with params: Main.Fetch.Parameters) -> AnyPublisher<Main.Fetch.Response, Main.AppError> {
        worker
            .fetch()
            .receive(on: DispatchQueue.global(qos: .background))
            .map { [weak self] model in
                self?.model = model
                return Main.Fetch.Response(model: model)
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }

    func close(with params: Main.Close.Parameters) -> AnyPublisher<Main.Close.Response, Never> {
        Just(Main.Close.Response())
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func increase(with params: Main.Increase.Parameters) -> AnyPublisher<Main.Increase.Response, Never> {
        guard let model else {
            return Empty<Main.Increase.Response, Never>().eraseToAnyPublisher()
        }
        if model.product.amount < 10 {
            self.model?.product.amount += 1
        }
        updateCurrentPrice()
        return Just(Main.Increase.Response(model: self.model))
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func decrease(with params: Main.Decrease.Parameters) -> AnyPublisher<Main.Decrease.Response, Never> {
        guard let model else {
            return Empty<Main.Decrease.Response, Never>().eraseToAnyPublisher()
        }
        if model.product.amount > 1 {
            self.model?.product.amount -= 1
        }
        updateCurrentPrice()
        return Just(Main.Decrease.Response(model: self.model))
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func selectedType(with params: Main.SelectedType.Parameters) -> AnyPublisher<Main.SelectedType.Response, Never> {
        model?.selectedType = params.index
        return Just(Main.SelectedType.Response(model: model))
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func selectedAdditional(with params: Main.SelectedAdditional.Parameters) -> AnyPublisher<Main.SelectedAdditional.Response, Never> {
        guard var model else {
            return Empty<Main.SelectedAdditional.Response, Never>().eraseToAnyPublisher()
        }
        if model.selectedAdditionals.contains(params.index) {
            model.selectedAdditionals.remove(params.index)
        }
        else {
            model.selectedAdditionals.insert(params.index)
        }
        self.model = model
        updateCurrentPrice()
        return Just(Main.SelectedAdditional.Response(model: self.model))
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func enterComment(with params: Main.EnterComment.Parameters) -> AnyPublisher<Main.EnterComment.Response, Never> {
        model?.instructions = params.text
        return Just(Main.EnterComment.Response(model: model))
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    func add(with params: Main.Add.Parameters) -> AnyPublisher<Main.Add.Response, Main.AppError> {
        guard var model else {
            return Fail(error: .unknown).eraseToAnyPublisher()
        }
        return worker
            .add(model: model)
            .receive(on: DispatchQueue.global(qos: .background))
            .map { [weak self] _ in
                guard let self else { return Main.Add.Response() }
                model.total += model.current
                model.current = model.product.price
                model.product.amount = 1
                model.selectedType = nil
                model.selectedAdditionals = []
                model.instructions = ""
                self.model = model
                updateCurrentPrice()
                return Main.Add.Response(model: self.model)
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }

    func basket(with params: Main.Basket.Parameters) -> AnyPublisher<Main.Basket.Response, Never> {
        Just(Main.Basket.Response())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }

    private func updateCurrentPrice(){
        guard let model else { return }
        var additionalsPrice = 0.0
        model.selectedAdditionals.forEach { item in
            additionalsPrice += model.additional[item].price
        }
        self.model?.current = (model.product.price + additionalsPrice) * Double(model.product.amount)
    }
}

// MARK: Implementation of Data Store for interacting with other scenes
extension MainInteractor: MainDataStore {}
