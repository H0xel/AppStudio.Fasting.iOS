//
//  ProductProviderImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 11.08.2023.
//

import AppStudioFoundation
import AppStudioSubscriptions
import Dependencies

private let weeklyProductId = "com.municorn.Fasting.weekly_exp_1"
private let weeklyProductIdWithoutTrial = "com.municorn.Fasting.weekly_exp_2"
private let monthlyProductId = "com.municorn.Fasting.monthly_exp_1"
private let yearlyProductId = "com.municorn.Fasting.yearly_exp_1"

private let weeklyExp3ProductId = "com.municorn.Fasting.weekly_exp_3"
private let weeklyExp4ProductId = "com.municorn.Fasting.weekly_exp_4"
private let weeklyExp5ProductId = "com.municorn.Fasting.weekly_exp_5"

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

    // TODO: SETUP default product list
    var defaultProductIds: [String] {
        [weeklyProductId, weeklyProductIdWithoutTrial]
    }

    // TODO: SETUP add all product items here
    var productItems: [ProductCatalogItem] = {
        [
            ProductCatalogItem(productId: weeklyProductId, duration: .week, isTrial: true),
            ProductCatalogItem(productId: weeklyProductIdWithoutTrial, duration: .week, isTrial: false),
            ProductCatalogItem(productId: yearlyProductId, duration: .year, isTrial: false),
            ProductCatalogItem(productId: weeklyExp3ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: weeklyExp4ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: weeklyExp5ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: "com.municorn.Fasting.yearly_exp_6", duration: .year, isTrial: false),
        ]
    }()
}
