//  
//  NotificationsInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.06.2024.
//

import AppStudioServices

struct NotificationsInput {
    let context: Context

    enum Context: String {
        case onboarding
        case settings

        var paywallContext: PaywallContext {
            switch self {
            case .onboarding: return .onboardingNotificationSettings
            case .settings: return .notificationSettings
            }
        }
    }
}
