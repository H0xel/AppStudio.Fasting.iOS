//
//  NotificationCenterInitializer.swift
//  Fasting
//
//  Created by Denis Khlopin on 15.11.2023.
//

import Dependencies
import UserNotifications
import AppStudioServices
import UIKit

class NotificationCenterInitializer: AppInitializer {

    @Dependency(\.notificationCenterDelegate) private var delegate
    @Dependency(\.firstLaunchService) private var firstLaunchService

    func initialize() {
        UNUserNotificationCenter.current().delegate = delegate
        registerRemoteNotification()
    }

    private func registerRemoteNotification() {
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            if settings.authorizationStatus == .authorized, !firstLaunchService.isFirstTimeLaunch {
                await UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
