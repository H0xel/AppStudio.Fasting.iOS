//  
//  LocalNotificationServiceImpl.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Foundation
import UserNotifications

class LocalNotificationServiceImpl: LocalNotificationService {
    
    func register(_ notification: LocalNotification, at date: DateComponents) async throws {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: notification.id,
                                            content: notification.content,
                                            trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func clearPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func clearPendingNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    private func requestAuthorization() async throws -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return !(settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied)
    }
}
