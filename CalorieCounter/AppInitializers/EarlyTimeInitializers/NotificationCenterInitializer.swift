//
//  NotificationCenterInitializer.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Dependencies
import UserNotifications
import AppStudioServices

class NotificationCenterInitializer: AppInitializer {

    @Dependency(\.notificationCenterDelegate) private var delegate

    func initialize() {
        UNUserNotificationCenter.current().delegate = delegate
    }
}
