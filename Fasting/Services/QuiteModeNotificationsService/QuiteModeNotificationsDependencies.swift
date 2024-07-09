//  
//  QuiteModeNotificationsDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 25.06.2024.
//

import Dependencies

extension DependencyValues {
    var quiteModeNotificationsService: QuiteModeNotificationsService {
        self[QuiteModeNotificationsServiceKey.self]
    }
}

private enum QuiteModeNotificationsServiceKey: DependencyKey {
    static var liveValue: QuiteModeNotificationsService = QuiteModeNotificationsServiceImpl()
    static var testValue: QuiteModeNotificationsService = QuiteModeNotificationsServiceImpl()
    static var previewValue: QuiteModeNotificationsService = QuiteModeNotificationsServiceImpl()
}
