//
//  QuickActionDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import Dependencies

extension DependencyValues {
    var quickActionTypeServiceService: QuickActionService {
        self[QuickActionTypeServiceKey.self]
    }
}

private enum QuickActionTypeServiceKey: DependencyKey {
    static var liveValue: QuickActionService = QuickActionServiceImpl()
}
