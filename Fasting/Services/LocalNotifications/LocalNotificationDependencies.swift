//
//  FastingLocalNotificationDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 14.11.2023.
//

import UserNotifications
import Dependencies

extension DependencyValues {
    var fastingLocalNotificationService: FastingLocalNotificationService {
        self[FastingLocalNotificationServiceKey.self]
    }
}

private enum FastingLocalNotificationServiceKey: DependencyKey {
    static var liveValue: FastingLocalNotificationService = FastingLocalNotificationServiceImpl()
    static var testValue: FastingLocalNotificationService = FastingLocalNotificationServiceImpl()
}
