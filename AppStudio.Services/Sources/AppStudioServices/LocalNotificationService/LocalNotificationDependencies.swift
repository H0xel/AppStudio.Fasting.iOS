//  
//  LocalNotificationDependencies.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Dependencies

public extension DependencyValues {
    var localNotificationService: LocalNotificationService {
        self[LocalNotificationServiceKey.self]
    }
}

private enum LocalNotificationServiceKey: DependencyKey {
    static var liveValue: LocalNotificationService = LocalNotificationServiceImpl()
    static var testValue: LocalNotificationService = LocalNotificationServiceImpl()
    static var previewValue: LocalNotificationService = LocalNotificationServiceImpl()
}
