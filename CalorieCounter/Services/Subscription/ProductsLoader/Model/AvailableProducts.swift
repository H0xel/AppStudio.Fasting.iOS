//
//  AvailableProducts.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//

import Foundation

struct AvailableProducts: Codable {
    let products: RemoteProducts
}

extension AvailableProducts {
    static let empty: AvailableProducts = .init(products: .init(subscriptionGroups: [:]))
}

extension AvailableProducts: Equatable {
    static func == (lhs: AvailableProducts, rhs: AvailableProducts) -> Bool {
        lhs.json() == rhs.json()
    }
}
