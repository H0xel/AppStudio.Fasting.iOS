//  
//  PromoPaywallServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 13.02.2024.
//

import Dependencies
import StoreKit

class PromoPaywallServiceImpl: PromoPaywallService {
    @Dependency(\.subscriptionsLoaderService) private var subscriptionsLoaderService
    @Dependency(\.cloudStorage) private var cloudStorage

    var pricingExperimentSKProduct: SKProduct? {
        skProducts.first(where: { $0.productIdentifier == firstRemoteSubscriptionId })
    }

    private var skProducts: [SKProduct] {
        subscriptionsLoaderService.subscriptions
    }

    private var firstRemoteSubscriptionId: String? {
        cloudStorage.pricingExperimentProductIds?.first
    }
}

extension SKProduct {
    func paywallDescription(isTrialAvailable: Bool) -> String? {
        guard let promotion = self.introductoryPrice else {
            return String(
                format: NSLocalizedString("PersonalizedPaywall.getPlus", comment: ""),
                self.formattedPrice ?? ""
            )
        }
        switch promotion.paymentMode {
        case .payAsYouGo, .payUpFront:
            return String(
                format: NSLocalizedString("PersonalizedPaywall.renewsAt", comment: ""),
                self.formattedPrice ?? ""
            )
        case .freeTrial:
            return isTrialAvailable
            ? String(format: NSLocalizedString("Paywall.tryForFree", comment: ""),
                     self.formattedPrice ?? "")
            : String(format: NSLocalizedString("PersonalizedPaywall.getPlus", comment: ""),
                     self.formattedPrice ?? "")
        @unknown default:
            return nil
        }
    }
}

extension SKProduct {
    var promoPriceLocale: String? {
        guard let promo = self.introductoryPrice, promo.paymentMode != .freeTrial else { return nil }

        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = promo.priceLocale
        return numberFormatter.string(from: promo.price)
    }

    var promoDuration: String? {
        guard let promo = self.introductoryPrice, promo.paymentMode != .freeTrial else { return nil }

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

    var formattedPrice: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = priceLocale

        guard let priceStr = numberFormatter.string(from: price) else {
            return nil
        }

        var period: String {
            switch subscriptionPeriod?.unit {
            case .day: return subscriptionPeriod?.numberOfUnits == 7 ? "week" : "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            case .none: return ""
            @unknown default:
                return ""
            }
        }

        let durationString = NSLocalizedString("ProductCatalog.duration.\(period)",
                                               comment: "duration")
        let result = String(format: NSLocalizedString("ProductCatalog.priceTitle", comment: "per"),
                            priceStr, durationString)
        return result
    }
}
