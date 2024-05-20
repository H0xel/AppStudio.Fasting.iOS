//
//  AnalyticEvent.swift
//  
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case idfaShown(afId: String?)
    case idfaAnswered(isGranted: Bool, afId: String?)
    case tapSubscribe(context: PaywallContext,
                      productId: String,
                      type: AnalyticEventType,
                      afId: String?)
    case tapRestorePurchases(context: PaywallContext, afId: String?)
    case paywallShown(context: PaywallContext, type: AnalyticEventType, afId: String?)
    // swiftlint:disable enum_case_associated_values_count
    case purchaseFinished(context: PaywallContext,
                          result: String,
                          message: String,
                          productId: String,
                          type: AnalyticEventType,
                          afId: String?)
    // swiftlint:enable enum_case_associated_values_count
    case restoreFinished(context: PaywallContext, result: RestoreResult, afId: String?)
    case afFirstSubscribe
    case tapClosePaywall(context: PaywallContext)
    case launchFromPush
    case notificationTapped(type: DeepLink)


    var name: String {
        switch self {
        case .idfaShown: return "Idfa access dialog shown"
        case .idfaAnswered: return "Idfa access answered"
        case .tapRestorePurchases: return "Tap restore purchases"
        case .tapSubscribe: return "Tap subscribe"
        case .paywallShown: return "Paywall shown"
        case .purchaseFinished: return "Purchase finished"
        case .restoreFinished: return "Restore finished"
        case .afFirstSubscribe: return "af_first_subscribe"
        case .tapClosePaywall: return "Tap close paywall"
        case .launchFromPush: return "Launch from push"
        case .notificationTapped: return "Notification tapped"
        }
    }

    var forAppsFlyer: Bool {
        switch self {
        case .afFirstSubscribe: true
        default: false
        }
    }
}
