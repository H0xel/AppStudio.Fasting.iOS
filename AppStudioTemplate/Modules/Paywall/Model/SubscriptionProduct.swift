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

    public init(id: String,
                title: String,
                titleDetails: String,
                durationTitle: String,
                promotion: String? = nil) {
        self.id = id
        self.title = title
        self.titleDetails = titleDetails
        self.promotion = promotion
        self.durationTitle = durationTitle
    }
}
