//
//  SubscriptionProduct.swift
//  Mileage.iOS
//
//  Created by Denis Khlopin on 09.08.2023.
//

import Foundation

struct SubscriptionProduct: Hashable {
    let id: String
    let title: String
    let titleDetails: String
    var promotion: String?
    let durationTitle: String
    let pricePerWeek: String
    let price: String

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

extension SubscriptionProduct {
    static var mock: SubscriptionProduct {
        .init(id: UUID().uuidString,
              title: "",
              titleDetails: "5.99 % per week",
              durationTitle: "1 month",
              pricePerWeek: "$5.99",
              price: "$129.99",
              promotion: "Save 79%")
    }
}
