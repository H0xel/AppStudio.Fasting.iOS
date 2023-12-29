//
//  QuickTypeInitializer.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import UIKit

final class QuickActionInitializer: AppInitializer {
    func initialize() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: QuickAction.review.rawValue,
                                      localizedTitle: QuickAction.review.title,
                                      localizedSubtitle: QuickAction.review.subTitle,
                                      icon: QuickAction.review.icon,
                                      userInfo: ["name": QuickAction.review.rawValue as NSSecureCoding])
        ]
    }
}
