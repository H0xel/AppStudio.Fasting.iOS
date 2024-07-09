//  
//  NotificationSettingsDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 19.06.2024.
//

import Dependencies

extension DependencyValues {
    var notificationSettingsService: NotificationSettingsService {
        self[NotificationSettingsServiceKey.self]
    }
}

private enum NotificationSettingsServiceKey: DependencyKey {
    static var liveValue: NotificationSettingsService = NotificationSettingsServiceImpl()
    static var testValue: NotificationSettingsService = NotificationSettingsServiceImpl()
    static var previewValue: NotificationSettingsService = NotificationSettingsServiceImpl()
}
