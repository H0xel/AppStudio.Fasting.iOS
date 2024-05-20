//  
//  DiscountPaywallInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import NewAppStudioSubscriptions
import Foundation
import AppStudioServices
import StoreKit

struct DiscountPaywallInput {
    let context: PaywallContext
    let paywallInfo: DiscountPaywallInfo
}

extension DiscountPaywallType {
    init(paywallInfo: DiscountPaywallInfo, subscription: Product) {
        let multiplier: Double = 1 - (Double(paywallInfo.discount ?? 0) / 100)

        let duration = subscription.subscription?.subscriptionPeriod.duration ?? .week

        var descriptionViewData: DiscountDescriptionView.ViewData {
            if paywallInfo.priceDisplay == "old_new" {
                return .oldNew(price: subscription.multipliedLocalizePrice(
                    for: duration,
                    multiplier: NSDecimalNumber(value: multiplier)) ?? "",
                               discountPrice: subscription.localizedPrice(for: duration) ?? "",
                               duration: duration.durationLocalized,
                               color: paywallInfo.paywallType == "discount_timer" ? .studioRed : .black)
            }

            return .perWeek(weekPrice: subscription.localizedPrice(for: .week) ?? "",
                            pricePerYear: subscription.multipliedLocalizePrice(
                                for: duration,
                                multiplier: NSDecimalNumber(value: multiplier)) ?? "",
                            discountPricePerYear: subscription.displayPrice,
                            color: paywallInfo.paywallType == "discount_timer" ? .studioRed : .black)
        }


        if paywallInfo.paywallType == "discount_timer" {
            self = .timer(.init(timerInterval: .init(seconds: paywallInfo.timerDurationInSeconds ?? 0),
                                discount: "\(paywallInfo.discount ?? 0)%",
                                descriptionViewData: descriptionViewData))
            return
        }

        self = .discount(.init(
            discountAmount: "\(paywallInfo.discount ?? 0)%",
            descriptionViewData: descriptionViewData)
        )
    }
}

extension SubscriptionDuration {
    var durationLocalized: String {
        NSLocalizedString("ProductCatalog.duration.\(rawValue)", comment: "Duration")
    }
}
