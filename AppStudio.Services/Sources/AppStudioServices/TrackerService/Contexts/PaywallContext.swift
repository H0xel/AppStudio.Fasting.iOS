//
//  PaywallContext.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import AppStudioAnalytics
import Foundation

public enum PaywallContext: String {
    case discountOnboarding = "discount_onbording"
    case discountPaywallTab = "discount_paywall_tab"
    case onboarding = "onbording"
    case paywallTab = "paywall_tab"
    case freeUsageLimit
    case fastingStages = "fasting_stages"
    case discountPin = "discount_pin"
    case fasting

    case discountMain = "discount_main"
    case logLimit = "log_limit"
    case barcodeScanner = "barcode_scanner"
    case macros

    case daily = "daily"
    case popup = "popup"
    case nova = "nova"
    case progress = "progress"

    case inAppPurchase = "in_app_purchase"
    case discountPush = "push_discount"
    case notificationSettings = "notification_settings"
    case onboardingNotificationSettings = "onboarding_notification_settings"
    case trialOffer = "trial_offer"
}

extension PaywallContext: TrackerParam {
    public var description: String {
        return self.rawValue
    }
}
