//
//  ProductProviderImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 11.08.2023.
//

import AppStudioFoundation
import AppStudioSubscriptions
import Dependencies

private let weeklyProductId = "com.municorn.CalorieCounter.weekly_exp_1"
private let threeMonthsProductId = "com.municorn.CalorieCounter.3monthly_exp_1"
private let yearProductId = "com.municorn.CalorieCounter.yearly_exp_1"
private let weeklyProductIdSecondExp = "com.municorn.CalorieCounter.weekly_exp_2"

class ProductProviderImpl: ProductProvider, AppInitializer {
    @Dependency(\.productsLoaderService) private var productsLoaderService
    func initialize() {

        Task {
            let availableProducts = try await productsLoaderService.load()
            if availableProducts == .empty {
                return
            }
            productItems = availableProducts.products
                .subscriptionGroups
                .flatMap { (_, plans: [RemoteExperimentPlans]) in
                    plans.map { plan in
                        ProductCatalogItem(productId: plan.productId,
                                           duration: .init(rawValue: plan.duration) ?? .week,
                                           isTrial: plan.isTrial)
                    }
                }
        }
    }

    var defaultProductIds: [String] {
        [weeklyProductId, threeMonthsProductId, yearProductId]
    }

    var productItems: [ProductCatalogItem] = {
        [
            ProductCatalogItem(productId: weeklyProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: threeMonthsProductId, duration: .threeMonth, isTrial: false),
            ProductCatalogItem(productId: yearProductId, duration: .year, isTrial: false),
            ProductCatalogItem(productId: weeklyProductIdSecondExp, duration: .week, isTrial: false),
        ]
    }()
}
