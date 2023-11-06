//
//  AppTab.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import Foundation

enum AppTab {
    case fasting
    case profile
    case paywall

    var navigationTitle: String? {
        switch self {
        case .profile:
            return NSLocalizedString("ProfileScreen.navigationTitle", comment: "Profile")
        case .fasting, .paywall:
            return nil
        }
    }
}
