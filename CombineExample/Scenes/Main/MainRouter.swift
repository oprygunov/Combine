//
//  MainRouter.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import UIKit

final class MainRouter {
    weak var viewController: MainViewController?
    let dataStore: MainDataStore

    // MARK: Initialization
    init(
        viewController: MainViewController,
        dataStore: MainDataStore
    ) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
}

// MARK: Implementation of Routing methods
extension MainRouter: MainRoutingLogic {
    func showBasket() { }

    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
