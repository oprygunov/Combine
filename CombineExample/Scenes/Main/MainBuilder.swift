//
//  MainBuilder.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import UIKit

final class MainBuilder {
    func build() -> UIViewController {
        let viewController = MainViewController()
        let interactor = MainInteractor(
            worker: MainWorker()
        )
        let presenter = MainPresenter(
            interactor:  interactor
        )
        let router = MainRouter(
            viewController: viewController,
            dataStore: interactor
        )
        viewController.presenter = presenter
        viewController.router = router
        return viewController
    }
}
