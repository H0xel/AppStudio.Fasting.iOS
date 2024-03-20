//  
//  DiscountPaywallInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import AppStudioSubscriptions
import Foundation
import AppStudioServices

struct DiscountPaywallInput {
    let context: PaywallContext
    let paywallInfo: DiscountPaywallInfo
}

extension DiscountPaywallType {
    init(paywallInfo: DiscountPaywallInfo, subscription: Subscription) {
        let multiplier: Double = 1 - (Double(paywallInfo.discount ?? 0) / 100)

        var descriptionViewData: DiscountDescriptionView.ViewData {
            if paywallInfo.priceDisplay == "old_new" {
                return .oldNew(price: subscription.multipliedLocalePrice(
                    for: subscription.duration,
                    multiplier: NSDecimalNumber(value: multiplier)) ?? "",
                               discountPrice: subscription.localedPrice(for: subscription.duration) ?? "",
                               duration: subscription.duration.durationLocalized,
                               color: paywallInfo.paywallType == "discount_timer" ? .studioRed : .black)
            }

            return .perWeek(weekPrice: subscription.localedPrice(for: .week) ?? "",
                            pricePerYear: subscription.multipliedLocalePrice(
                                for: subscription.duration,
                                multiplier: NSDecimalNumber(value: multiplier)) ?? "",
                            discountPricePerYear: subscription.formattedPrice ?? "",
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

extension Subscription {
    func multipliedLocalePrice(for duration: SubscriptionDuration, multiplier: NSDecimalNumber) -> String? {
        let price: Price? =
        switch duration {
        case .week: pricePerWeek
        case .month: priceByMonth
        case .threeMonth: Price(currency: priceByMonth?.currency ?? "",
                                value: (priceByMonth?.value ?? 0).multiplying(by: 3))
        case .sixMonth:
            Price(currency: priceByMonth?.currency ?? "",
                  value: (priceByMonth?.value ?? 0).multiplying(by: 6))
        case .year:
            pricePerYear
        }
        guard let price else {
            return nil
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale

        return numberFormatter.string(from: price.value.dividing(by: multiplier).round(0).adding(0.99))
    }
}

extension SubscriptionDuration {
    var durationLocalized: String {
        NSLocalizedString("ProductCatalog.duration.\(rawValue)", comment: "Duration")
    }
}


extension NSDecimalNumber {
    public func round(_ decimals: Int) -> NSDecimalNumber {
        return self.rounding(accordingToBehavior:
                                NSDecimalNumberHandler(roundingMode: .down,
                                                       scale: Int16(decimals),
                                                       raiseOnExactness: false,
                                                       raiseOnOverflow: false,
                                                       raiseOnUnderflow: false,
                                                       raiseOnDivideByZero: false))
    }
}
