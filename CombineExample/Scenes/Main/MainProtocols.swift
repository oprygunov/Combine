//
//  MainProtocols.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import Combine

protocol MainPresentable: AnyObject {
    func fetch(with params: Main.Fetch.Parameters) -> AnyPublisher<Main.Fetch.ViewModel, Main.AppError>
    func close(with params: Main.Close.Parameters) -> AnyPublisher<Main.Close.ViewModel, Never>
    func increase(with params: Main.Increase.Parameters) -> AnyPublisher<Main.Increase.ViewModel, Never>
    func decrease(with params: Main.Decrease.Parameters) -> AnyPublisher<Main.Decrease.ViewModel, Never>
    func selectedType(with params: Main.SelectedType.Parameters) -> AnyPublisher<Main.SelectedType.ViewModel, Never>
    func selectedAdditional(with params: Main.SelectedAdditional.Parameters) -> AnyPublisher<Main.SelectedAdditional.ViewModel, Never>
    func enterComment(with params: Main.EnterComment.Parameters) -> AnyPublisher<Main.EnterComment.ViewModel, Never>
    func add(with params: Main.Add.Parameters) -> AnyPublisher<Main.Add.ViewModel, Main.AppError>
    func basket(with params: Main.Basket.Parameters) -> AnyPublisher<Main.Basket.ViewModel, Never>
}

protocol MainInteractable: AnyObject {
    func fetch(with params: Main.Fetch.Parameters) -> AnyPublisher<Main.Fetch.Response, Main.AppError>
    func close(with params: Main.Close.Parameters) -> AnyPublisher<Main.Close.Response, Never>
    func increase(with params: Main.Increase.Parameters) -> AnyPublisher<Main.Increase.Response, Never>
    func decrease(with params: Main.Decrease.Parameters) -> AnyPublisher<Main.Decrease.Response, Never>
    func selectedType(with params: Main.SelectedType.Parameters) -> AnyPublisher<Main.SelectedType.Response, Never>
    func selectedAdditional(with params: Main.SelectedAdditional.Parameters) -> AnyPublisher<Main.SelectedAdditional.Response, Never>
    func enterComment(with params: Main.EnterComment.Parameters) -> AnyPublisher<Main.EnterComment.Response, Never>
    func add(with params: Main.Add.Parameters) -> AnyPublisher<Main.Add.Response, Main.AppError>
    func basket(with params: Main.Basket.Parameters) -> AnyPublisher<Main.Basket.Response, Never>
}

protocol MainRoutingLogic: AnyObject {
    func showBasket()
    func close()
}

protocol MainDataStore: AnyObject {}

protocol MainWorkable: AnyObject {
    func fetch() -> AnyPublisher<Main.Model, Main.AppError>
    func add(model: Main.Model) -> AnyPublisher<Void, Main.AppError>
}
