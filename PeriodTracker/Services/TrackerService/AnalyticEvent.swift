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
        case .tapClosePaywall: "Tap close paywall"
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
