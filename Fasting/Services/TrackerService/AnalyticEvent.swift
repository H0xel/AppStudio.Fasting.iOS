//
//  AnalyticEvent.swift
//  Fasting
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case launch(firstTime: Bool, afId: String?)
    case idfaShown(afId: String?)
    case idfaAnswered(isGranted: Bool, afId: String?)

    case startedExperiment(expName: String, variantId: String)
    case appliedForcedVariant(expName: String, variantId: String)

    case tapClosePaywall
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
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .launch: return "App launched"
        case .idfaShown: return "Idfa access dialog shown"
        case .idfaAnswered: return "Idfa access answered"
        case .startedExperiment: return "Experiment started"
        case .appliedForcedVariant: return "Forced variant applied"
        case .tapSubscribe: return "Tap subscribe"
        case .tapClosePaywall: return "Tap close paywall"
        case .tapRestorePurchases: return "Tap restore purchases"
        case .paywallShown: return "Paywall shown"
        case .purchaseFinished: return "Purchase finished"
        case .restoreFinished: return "Restore finished"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}

enum AnalyticEventType: String {
    case main
    case promo
}
