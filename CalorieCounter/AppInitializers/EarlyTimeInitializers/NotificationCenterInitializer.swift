//
//  NotificationCenterInitializer.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 24.04.2024.
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
