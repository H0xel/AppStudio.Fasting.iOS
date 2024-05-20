//
//  Product+extensions.swift
//  
//
//  Created by Amakhin Ivan on 01.05.2024.
//

import StoreKit
import NewAppStudioSubscriptions
import AppStudioModels

public extension Product {
    func asSubscriptionProduct(for duration: NewAppStudioSubscriptions.SubscriptionDuration = .week,
                               promotion: String?) -> SubscriptionProduct {
        .init(id: id,
              title: displayName,
              titleDetails: displayPrice,
              durationTitle: duration.title,
              pricePerWeek: localizedPrice(for: .week) ?? "",
              price: displayPrice,
              promotion: promotion)
    }

    func paywallDescription(isTrialAvailable: Bool) -> String? {
        guard let promotion = subscription?.introductoryOffer else {
            return String(
                format: NSLocalizedString("PersonalizedPaywall.getPlus", comment: ""),
                displayPrice
            )
        }
        switch promotion.paymentMode {
        case .payAsYouGo, .payUpFront:
            return String(
                format: NSLocalizedString("PersonalizedPaywall.renewsAt", comment: ""),
                displayPrice
            )
        case .freeTrial:
            return isTrialAvailable
            ? String(format: NSLocalizedString("Paywall.tryForFree", comment: ""),
                     displayPrice)
            : String(format: NSLocalizedString("PersonalizedPaywall.getPlus", comment: ""),
                     displayPrice)
        default:
            return nil
        }
    }

    var promoPriceLocale: String? {
        guard let promo = subscription?.introductoryOffer, promo.paymentMode != .freeTrial else { return nil }
        return promo.displayPrice
    }

    var promoDuration: String? {
        guard let promo = subscription?.introductoryOffer, promo.paymentMode != .freeTrial else { return nil }

        let unit = promo.period.value

        var form: String {
            unit > 1 ? "form2" : "form1"
        }

        var period: String {
            switch promo.period.unit {
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

    func multipliedLocalizePrice(for duration: SubscriptionDuration, multiplier: NSDecimalNumber) -> String? {
        guard let subscriptionDuration = subscription?.subscriptionPeriod.duration else { return nil }

        var priceAmount: Decimal? {
            price * Decimal(subscriptionDuration.timeIntervalsInDuration(duration))
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = priceFormatStyle.locale

        return numberFormatter.string(from: ((priceAmount ?? 0) as NSDecimalNumber)
            .dividing(by: multiplier)
            .round(0)
            .adding(0.99)
        )
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

