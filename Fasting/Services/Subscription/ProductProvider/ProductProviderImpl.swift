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
    //    private let weeklyProductId = "app.app.premium.weekly"
    //    private let monthlyProductId = "app.app.premium.monthly"

    // TODO: SETUP default product list
    var defaultProductIds: [String] {
        // EXAMPLE: - [monthlyExp3ProductId]
        []
    }

    // TODO: SETUP add all product items here
    var productItems: [ProductCatalogItem] {
        // EXAMPLE
        //        [
        //            ProductCatalogItem(productId: weeklyProductId, duration: .week, isTrial: true),
        //            ProductCatalogItem(productId: monthlyProductId, duration: .month, isTrial: false)
        //        ]
        []
    }
}
