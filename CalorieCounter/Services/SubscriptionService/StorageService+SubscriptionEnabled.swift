//
//  StorageService+SubscriptionEnabled.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 25.01.2024.
//

import MunicornFoundation

private let subscriptionEnabledKey = "AppStudio.subscriptionEnabledKey"
extension StorageService {
    var isSubscriptionEnabled: Bool {
        set { set(key: subscriptionEnabledKey, value: newValue) }
        get { get(key: subscriptionEnabledKey, defaultValue: false) }
    }
}
