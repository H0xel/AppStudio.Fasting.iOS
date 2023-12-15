//
//  ProductProviderImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 11.08.2023.
//

import AppStudioFoundation
import AppStudioSubscriptions

class ProductProviderImpl: ProductProvider {
    // TODO: SETUP products here
    // EXAMPLE:
        private let weeklyProductId = "com.municorn.Fasting.weekly_exp_1"
        private let weeklyProductIdWithoutTrial = "com.municorn.Fasting.weekly_exp_2"
        private let monthlyProductId = "com.municorn.Fasting.monthly_exp_1"
        private let yearlyProductId = "com.municorn.Fasting.yearly_exp_1"
    // TODO: SETUP default product list
    var defaultProductIds: [String] {
        // EXAMPLE: - [monthlyExp3ProductId]
        [weeklyProductId, weeklyProductIdWithoutTrial]
    }

    // TODO: SETUP add all product items here
    var productItems: [ProductCatalogItem] {
        [
            ProductCatalogItem(productId: weeklyProductId, duration: .week, isTrial: true),
            ProductCatalogItem(productId: weeklyProductIdWithoutTrial, duration: .week, isTrial: false)
        ]
    }
}
