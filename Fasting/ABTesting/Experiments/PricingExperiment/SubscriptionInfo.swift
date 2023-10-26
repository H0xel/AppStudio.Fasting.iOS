//
//  SubscriptionInfo.swift
//  Scanner
//
//  Created by Александр Бочкарев on 15.09.2020.
//  Copyright © 2020 Scanner. All rights reserved.

import Dependencies
import AppStudioABTesting

struct SubscriptionInfo: Named, Equatable {

    var name: String
    let productIds: [String]

    static var base: SubscriptionInfo = {
        @Dependency(\.productProvider) var productProvider
        return SubscriptionInfo(name: "base", productIds: productProvider.defaultProductIds)
    }()
}

extension SubscriptionInfo: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: RawValue) { nil }
    var rawValue: RawValue { name }
}

extension SubscriptionInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case productIds = "product_ids"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        productIds = try container.decode([String].self, forKey: .productIds)
    }
}
