//
//  AnalyticEvent.swift
//  AppStudioTemplate
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
    case pushDialogAnswered(isGranted: Bool)
    case serverError(code: Int, message: String, details: String?, traceId: String?, path: String)
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .launch: "App launched"
        case .idfaShown: "Idfa access dialog shown"
        case .idfaAnswered: "Idfa access answered"
        case .startedExperiment: "Experiment started"
        case .appliedForcedVariant: "Forced variant applied"
        case .tapSubscribe: "Tap subscribe"
        case .tapClosePaywall: "Tap close paywall"
        case .tapRestorePurchases: "Tap restore purchases"
        case .paywallShown: "Paywall shown"
        case .purchaseFinished: "Purchase finished"
        case .restoreFinished: "Restore finished"
        case .pushDialogAnswered: "Push dialog answered"
        case .serverError: "Server error"
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
