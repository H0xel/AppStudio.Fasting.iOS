//
//  LocalNotificationService.swift
//  Fasting
//
//  Created by Denis Khlopin on 13.11.2023.
//

import Foundation
import UserNotifications

protocol FastingLocalNotificationService {
    func updateNotifications(interval: FastingInterval, isProcessing: Bool)
}
