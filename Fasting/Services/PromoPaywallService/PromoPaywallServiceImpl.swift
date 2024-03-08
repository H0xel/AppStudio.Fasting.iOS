//  
//  PromoPaywallServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 13.02.2024.
//

import Dependencies
import RxSwift
import StoreKit

class PromoPaywallServiceImpl: PromoPaywallService {
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.productIdsService) private var productIdsService


    var promoSubscription: Observable<PromotionalOffer?> {
        Observable.combineLatest(promotionExperimentPlan, subscriptionService.subscriptionProducts)
            .map { experimentPromotion, subscriptions in
                if let promoSubscription = subscriptions
                    .first(where: { $0.productIdentifier == experimentPromotion?.productId })?
                    .product {
                    return .init(
                        id: promoSubscription.productIdentifier,
                        duration: promoSubscription.promoDuration ?? "",
                        price: promoSubscription.promoPriceLocale ?? "",
                        product: promoSubscription
                    )
                }
                return nil
            }
    }

    private var promotionExperimentPlan: Observable<RemoteExperimentPlans?> {
        Observable.combineLatest(productIdsService.productIds, remoteProducts)
            .map { productIds, remoteProducts in (productIds.first, remoteProducts) }
            .map { productId, remoteProducts in remoteProducts.first(where: { $0.productId == productId }) }
            .filter { $0?.introOffer == .payUpFront }
    }

    private var remoteProducts: Observable<[RemoteExperimentPlans]> {
        appCustomization.allProductsObservable
            .map { $0.products.subscriptionGroups.flatMap { $0.value } }
    }
}

struct PromotionalOffer: Equatable {
    let id: String
    let duration: String
    let price: String
    let product: SKProduct
}

private extension SKProduct {
    var promoPriceLocale: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = self.introductoryPrice?.priceLocale
        return numberFormatter.string(from: self.introductoryPrice?.price ?? 0)
    }

    var promoDuration: String? {
        guard let promo = self.introductoryPrice else { return nil }

        let unit = promo.subscriptionPeriod.numberOfUnits

        var form: String {
            unit > 1 ? "form2" : "form1"
        }

        var period: String {
            switch promo.subscriptionPeriod.unit {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            @unknown default:
                return ""
            }
        }

        return "\(unit)" + " " + NSLocalizedString("ProductCatalog.duration.\(period).\(form)", comment: "")
    }
}
