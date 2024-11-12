//
//  MainWorker.swift
//  Combine
//
//  Created by Oleg Prygunov on 11.07.2023.
//  Copyright (c) 2023. All rights reserved.
//

import Combine
import Foundation

final class MainWorker: MainWorkable {
    func fetch() -> AnyPublisher<Main.Model, Main.AppError> {
        let publisher = Future<Main.Model, Main.AppError> { completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                completion(
                    .success(
                        .init(
                            product: .init(
                                identifier: 115,
                                image: "oproduct",
                                name: "Udon Miso",
                                description: "Our Udon Miso is a comforting bowl of thick, handmade udon noodles in a rich miso broth, garnished with tofu, spring onions, and vegetables.",
                                price: 16.0,
                                amount: 1
                            ),
                            type: [
                                .init(
                                    identifier: 1,
                                    name: "Thin"
                                ),
                                .init(
                                    identifier: 2,
                                    name: "Thick"
                                ),
                                .init(
                                    identifier: 3,
                                    name: "Udon"
                                ),
                                .init(
                                    identifier: 4,
                                    name: "Shirataki"
                                )
                            ],
                            additional: [
                                .init(
                                    identifier: 1,
                                    name: "Braised Pork",
                                    price: 3.99
                                ),
                                .init(
                                    identifier: 2,
                                    name: "Soft Boiled Egg",
                                    price: 2.99
                                ),
                                .init(
                                    identifier: 3,
                                    name: "Bamboo Shoots",
                                    price: 2.99
                                ),
                                .init(
                                    identifier: 4,
                                    name: "Corn",
                                    price: 1.99
                                )
                            ],
                            instructions: "",
                            current: 16.0,
                            total: 0.0
                        )
                    )
                )
            }
        }
            .subscribe(on: DispatchQueue.global(qos: .background))
        return publisher
            .eraseToAnyPublisher()
    }

    func add(model: Main.Model) -> AnyPublisher<Void, Main.AppError> {
        let publisher = Future<Void, Main.AppError> { completion in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                print("add")
                completion(.success(()))
            }
        }
        return publisher
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}
