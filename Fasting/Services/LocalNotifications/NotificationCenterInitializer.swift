//
//  NotificationCenterInitializer.swift
//  Fasting
//
//  Created by Denis Khlopin on 15.11.2023.
//

import Dependencies
import UserNotifications

class NotificationCenterInitializer: AppInitializer {

    @Dependency(\.notificationCenterDelegate) private var delegate

    func initialize() {
        UNUserNotificationCenter.current().delegate = delegate
    }
}
