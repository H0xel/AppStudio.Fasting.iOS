//
//  NotificationCenterDelegate.swift
//  ExpensesServices
//
//  Created by Руслан Сафаргалеев on 03.05.2023.
//

import UserNotifications
import Dependencies

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {

    @Dependency(\.trackerService) private var trackerService

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        trackerService.track(.launchFromPush)
        completionHandler()
    }
}
