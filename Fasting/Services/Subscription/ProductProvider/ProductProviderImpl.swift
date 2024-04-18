//
//  ProductProviderImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 11.08.2023.
//

import AppStudioFoundation
import AppStudioSubscriptions
import Dependencies
import AppStudioServices

private let weeklyProductId = "com.municorn.Fasting.weekly_exp_1"
private let weeklyProductIdWithoutTrial = "com.municorn.Fasting.weekly_exp_2"
private let monthlyProductId = "com.municorn.Fasting.monthly_exp_1"
private let yearlyProductId = "com.municorn.Fasting.yearly_exp_1"
private let yearlyProductIdExp6 = "com.municorn.Fasting.yearly_exp_6"

private let weeklyExp3ProductId = "com.municorn.Fasting.weekly_exp_3"
private let weeklyExp4ProductId = "com.municorn.Fasting.weekly_exp_4"
private let weeklyExp5ProductId = "com.municorn.Fasting.weekly_exp_5"

private let weeklyExp7ProductId = "com.municorn.Fasting.weekly_exp_7"
private let threeMonthlyExp7ProductId =  "com.municorn.Fasting.3monthly_exp_7"
private let earlyExp7ProductId =  "com.municorn.Fasting.yearly_exp_7"


class ProductProviderImpl: ProductProvider, AppInitializer {
    @Dependency(\.productsLoaderService) private var productsLoaderService
    @Dependency(\.subscriptionsLoaderService) private var subscriptionsLoaderService
    func initialize() {

        Task {
            let availableProducts = try await productsLoaderService.load()
            if availableProducts == .empty {
                return
            }
            productItems = availableProducts.products
                .subscriptionGroups
                .flatMap { (_, plans: [RemoteExperimentPlans]) in
                    remoteExperimentsPlans = plans
                    return plans.map { plan in
                        ProductCatalogItem(productId: plan.productId,
                                           duration: .init(rawValue: plan.duration) ?? .week,
                                           isTrial: plan.isTrial)
                    }
                }
        }
        subscriptionsLoaderService.initialize()
    }

    // TODO: SETUP default product list
    var defaultProductIds: [String] {
        [weeklyProductIdWithoutTrial]
    }

    var remoteExperimentsPlans: [RemoteExperimentPlans] = []

    // TODO: SETUP add all product items here
    var productItems: [ProductCatalogItem] = {
        [
            ProductCatalogItem(productId: weeklyProductId, duration: .week, isTrial: true),
            ProductCatalogItem(productId: weeklyProductIdWithoutTrial, duration: .week, isTrial: false),
            ProductCatalogItem(productId: yearlyProductId, duration: .year, isTrial: false),
            ProductCatalogItem(productId: monthlyProductId, duration: .month, isTrial: false),
            ProductCatalogItem(productId: weeklyExp3ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: weeklyExp4ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: weeklyExp5ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: yearlyProductIdExp6, duration: .year, isTrial: false),
            ProductCatalogItem(productId: weeklyExp7ProductId, duration: .week, isTrial: false),
            ProductCatalogItem(productId: threeMonthlyExp7ProductId, duration: .threeMonth, isTrial: false),
            ProductCatalogItem(productId: earlyExp7ProductId, duration: .year, isTrial: false),
        ]
    }()
}
