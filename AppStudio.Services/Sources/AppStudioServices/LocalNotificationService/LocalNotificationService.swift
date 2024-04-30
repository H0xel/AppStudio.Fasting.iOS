//  
//  LocalNotificationService.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Foundation

public protocol LocalNotificationService {
    func register(_ notification: LocalNotification, at date: DateComponents) async throws
    func clearPendingNotifications()
    func clearPendingNotification(id: String)
}
