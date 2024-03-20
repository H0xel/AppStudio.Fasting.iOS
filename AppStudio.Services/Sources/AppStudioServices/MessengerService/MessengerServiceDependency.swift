//
//  MessengerServiceDependency.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies

public extension DependencyValues {
    var messengerService: MessengerService {
        self[MessengerServiceKey.self]
    }
}

private enum MessengerServiceKey: DependencyKey {
    static var liveValue: MessengerService = MessengerServiceImpl()
}
