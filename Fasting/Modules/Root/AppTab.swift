//
//  AppTab.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import Foundation

enum AppTab: String {
    case fasting
    case coach
    case profile
    case paywall
    case healthProgress

    var navigationTitle: String? {
        switch self {
        case .profile:
            return NSLocalizedString("ProfileScreen.navigationTitle", comment: "Profile")
        case .fasting, .paywall, .coach, .healthProgress:
            return nil
        }
    }
}
