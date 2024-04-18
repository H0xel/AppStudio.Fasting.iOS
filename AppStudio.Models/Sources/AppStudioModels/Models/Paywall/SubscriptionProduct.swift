//
//  SubscriptionProduct.swift
//  Mileage.iOS
//
//  Created by Denis Khlopin on 09.08.2023.
//

import Foundation

public struct SubscriptionProduct: Hashable {
    public let id: String
    public let title: String
    public let titleDetails: String
    public var promotion: String?
    public let durationTitle: String
    public let pricePerWeek: String
    public let price: String

    public init(id: String,
                title: String,
                titleDetails: String,
                durationTitle: String,
                pricePerWeek: String,
                price: String,
                promotion: String? = nil) {
        self.id = id
        self.title = title
        self.titleDetails = titleDetails
        self.promotion = promotion
        self.pricePerWeek = pricePerWeek
        self.price = price
        self.durationTitle = durationTitle
    }
}

public extension SubscriptionProduct {
    static var mock: SubscriptionProduct {
        .init(id: UUID().uuidString,
              title: "",
              titleDetails: "5.99 % per week",
              durationTitle: "1 month",
              pricePerWeek: "$5.99",
              price: "$129.99",
              promotion: "Save 79%")
    }

    static var empty: SubscriptionProduct {
        .init(id: "", title: "", titleDetails: "", durationTitle: "", pricePerWeek: "", price: "")
    }
}

