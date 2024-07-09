//
//  CloudStorage+notificationSettings.swift
//  Fasting
//
//  Created by Amakhin Ivan on 19.06.2024.
//

import MunicornFoundation

private var notificationsSettingsKey = "Appstudio.notificationsSettingsKey"
private var notificationsSettingsWithSubscriptionKey = "Appstudio.notificationsSettingsWithSubscriptionKey"

extension CloudStorage {
    var notificationSettings: NotificationSettings? {
        get {
            let json: String? = get(key: notificationsSettingsKey)
            return try? NotificationSettings(json: json ?? "")
        }

        set {
            set(key: notificationsSettingsKey, value: newValue.json())
        }
    }

    var lastSavedNotificationSettingsWithSubscription: NotificationSettings? {
        get {
            let json: String? = get(key: notificationsSettingsWithSubscriptionKey)
            return try? NotificationSettings(json: json ?? "")
        }

        set {
            set(key: notificationsSettingsWithSubscriptionKey, value: newValue.json())
        }
    }
}
