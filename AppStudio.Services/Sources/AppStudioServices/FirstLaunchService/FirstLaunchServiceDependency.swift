//
//  FirstLaunchServiceDependency.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies

public extension DependencyValues {
    var firstLaunchService: FirstLaunchService {
        self[FirstLaunchServiceKey.self]
    }
}

private enum FirstLaunchServiceKey: DependencyKey {
    static var liveValue: FirstLaunchService = FirstLaunchServiceImpl()
}
