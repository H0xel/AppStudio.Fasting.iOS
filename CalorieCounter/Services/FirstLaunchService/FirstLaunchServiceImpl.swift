//
//  FirstLaunchServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 19.05.2023.
//

import MunicornFoundation
import Dependencies

final class FirstLaunchServiceImpl: FirstLaunchService {
    @Dependency(\.storageService) var storageService

    public var isFirstTimeLaunch: Bool

    public init() {
        isFirstTimeLaunch = true
        if storageService.firstLaunchRegistered {
            isFirstTimeLaunch = false
        }
    }

    public func markAsLaunched() {
        storageService.firstLaunchRegistered = true
    }
}
