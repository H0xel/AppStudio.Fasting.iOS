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
}

struct PaywallScreenInput: Equatable {
    let headerTitles: PaywallTitle
    let paywallContext: PaywallContext
    var paywallImage: Image?
}

extension PaywallScreenInput {
    static let onboarding = PaywallScreenInput(
        headerTitles: .defaultHeaderTitles,
        paywallContext: .onboarding,
        paywallImage: .paywall)

    static let fromSettings = PaywallScreenInput(
        headerTitles: .defaultHeaderTitles,
        paywallContext: .settingsScreen,
        paywallImage: .paywall)

    static let mock = PaywallScreenInput(
        headerTitles: .defaultHeaderTitles,
        paywallContext: .onboarding,
        paywallImage: .paywall)
}
