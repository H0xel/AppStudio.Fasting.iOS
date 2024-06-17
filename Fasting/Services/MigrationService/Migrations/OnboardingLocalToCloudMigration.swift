//
//  OnboardingLocalToCloudMigration.swift
//  Fasting
//
//  Created by Amakhin Ivan on 16.06.2024.
//

import Dependencies
import MunicornFoundation

class OnboardingLocalToCloudMigration: Migration {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.firstLaunchService) private var firstLaunchService

    func migrate() async {
        guard !firstLaunchService.isFirstTimeLaunch else { return }
        cloudStorage.onboardingIsFinished = storageService.onboardingIsFinished
    }
}

private let onboardingFinishedKey = "AppStudio.cloudOnboardingGinishKey"
extension CloudStorage {
    var onboardingIsFinished: Bool {
        get { get(key: onboardingFinishedKey, defaultValue: false) }
        set { set(key: onboardingFinishedKey, value: newValue) }
    }
}
