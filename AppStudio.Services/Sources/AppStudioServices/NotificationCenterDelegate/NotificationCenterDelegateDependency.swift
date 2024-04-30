//
//  NotificationCenterDelegateDependency.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import UserNotifications
import Dependencies

public extension DependencyValues {
    var notificationCenterDelegate: UNUserNotificationCenterDelegate {
        self[NotificationCenterDelegateKey.self]
    }
}

private enum NotificationCenterDelegateKey: DependencyKey {
    static let liveValue = NotificationCenterDelegate()
    static let testValue = NotificationCenterDelegate()
}
