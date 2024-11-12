//
//  MainModels.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import Foundation

enum Main {
    enum Fetch {
        struct Parameters {}

        struct Response {
            var model: Model?
            var error: Error?
        }

        struct ViewModel {
            var root: RootViewModel
            var error: String?
        }
    }

    enum Close {
        struct Parameters {}

        struct Response {}

        struct ViewModel {}
    }

    enum Increase {
        struct Parameters {}

        struct Response {
            var model: Model?
        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum Decrease {
        struct Parameters {}

        struct Response {
            var model: Model?
        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum SelectedType {
        struct Parameters {
            var index: Int
        }

        struct Response {
            var model: Model?
        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum SelectedAdditional {
        struct Parameters {
            var index: Int
        }

        struct Response {
            var model: Model?

        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum EnterComment {
        struct Parameters {
            var text: String
        }

        struct Response {
            var model: Model?
        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum Add {
        struct Parameters {}

        struct Response {
            var model: Model?
        }

        struct ViewModel {
            var root: RootViewModel
        }
    }

    enum Basket {
        struct Parameters {}

        struct Response {}

        struct ViewModel {}
    }

    enum AppError: Error {
        case unknown
    }

    struct Model {
        var product: Product
        var type: [TypeProduct]
        var additional: [Additional]
        var instructions: String
        var current: Double
        var total: Double
        var selectedType: Int?
        var selectedAdditionals: Set<Int> = []

        struct Product {
            var identifier: Int
            var image: String
            var name: String
            var description: String
            var price: Double
            var amount: Int
        }

        struct TypeProduct {
            var identifier: Int
            var name: String
        }

        struct Additional {
            var identifier: Int
            var name: String
            var price: Double
        }
    }

    struct RootViewModel {
        var product: Product
        var type: [TypeProduct]
        var additional: [Additional]
        var instructions: String
        var addToBasket: String
        var total: String

        struct Product {
            var identifier: String
            var image: String
            var name: String
            var description: String
            var price: String
            var amount: String
        }

        struct TypeProduct {
            var identifier: String
            var name: String
            var isSelected: Bool
        }

        struct Additional {
            var identifier: String
            var name: String
            var price: String
            var isSelected: Bool
        }
    }
}
