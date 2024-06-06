//
//  NotificationCenterDelegate.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import UserNotifications
import Dependencies
import Intercom

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {

    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.deepLinkService) private var deepLinkService

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if userInfo.isEmpty {
            trackerService.track(.launchFromPush)
        }

        if Intercom.isIntercomPushNotification(userInfo) {
            deepLinkService.set(.intercom)
        }

        if let deeplinkRawValue = userInfo["deepLink"] as? String, let deepLink = DeepLink(rawValue: deeplinkRawValue) {
            deepLinkService.set(deepLink)
        }
        completionHandler()
    }
}
