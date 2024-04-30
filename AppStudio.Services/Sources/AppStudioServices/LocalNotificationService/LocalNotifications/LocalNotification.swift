//
//  LocalNotification.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import UserNotifications
import AppStudioFoundation

public protocol LocalNotification {
    var id: String { get }
    var content: UNNotificationContent { get }
    var deepLink: DeepLink? { get }
}
