//
//  PaywallScreenInput.swift
//  Mileage.iOS
//
//  Created by Denis Khlopin on 09.08.2023.
//

import SwiftUI

struct PaywallTitle: Equatable {
    let title: String
    let description: String
    let subTitle: String

    static let defaultHeaderTitles = PaywallTitle(
        title: NSLocalizedString("Paywall.headerTitle", comment: ""),
        description: NSLocalizedString("Paywall.headerDescription", comment: ""),
        subTitle: NSLocalizedString("Paywall.headerBottomTitle", comment: "")
    )

    static let usageLimit = PaywallTitle(
        title: NSLocalizedString("Paywall.reachYourWeightGoals", comment: ""),
        description: NSLocalizedString("Paywall.tryForFree", comment: ""),
        subTitle: ""
    )

    static let onboardingTitle = PaywallTitle(
        title: NSLocalizedString("Paywall.reachYourWeightGoals", comment: ""),
        description: NSLocalizedString("Paywall.tryForFree", comment: ""),
        subTitle: NSLocalizedString("Paywall.headerBottomTitle", comment: "")
    )

    static let settingsTitle = PaywallTitle(
        title: NSLocalizedString("Paywall.reachYourWeightGoals", comment: ""),
        description: NSLocalizedString("Paywall.tryForFree", comment: ""),
        subTitle: NSLocalizedString("Paywall.headerBottomTitle", comment: "")
    )
}

struct PaywallScreenInput: Equatable {
    let headerTitles: PaywallTitle
    let paywallContext: PaywallContext
    var paywallImage: Image?
}

extension PaywallScreenInput {
    static let onboarding = PaywallScreenInput(
        headerTitles: .onboardingTitle,
        paywallContext: .onboarding,
        paywallImage: .paywall)

    static let fromSettings = PaywallScreenInput(
        headerTitles: .settingsTitle,
        paywallContext: .paywallTab,
        paywallImage: .paywall)

    static let mock = PaywallScreenInput(
        headerTitles: .defaultHeaderTitles,
        paywallContext: .onboarding,
        paywallImage: .paywall)

    static let freeUsageLimit = PaywallScreenInput(
        headerTitles: .usageLimit,
        paywallContext: .freeUsageLimit,
        paywallImage: nil
    )
}
