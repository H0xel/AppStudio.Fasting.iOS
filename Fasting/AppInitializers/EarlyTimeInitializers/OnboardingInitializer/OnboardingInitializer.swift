//
//  OnboardingInitializer.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.05.2024.
//

import Foundation
import Dependencies
import MunicornFoundation

final class OnboardingInitializer: AppInitializer {
    @Dependency(\.onboardingApi) private var onboardingApi
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.w2WLoadingService) private var w2WLoadingService

    func initialize() {
        Task {
            let onboardingResponse = try await onboardingApi.onboarding(.init(clientEmail: nil))
            if let onboardingData = onboardingResponse.onboarding, !cloudStorage.userWithOnboardingApi {
                userPropertyService.set(userProperties: ["w2w": true])
                onboardingService.save(data: .init(onboardingData))
                cloudStorage.userWithOnboardingApi = true
                tryToRestoreSubscriptionFromW2W()
            }
            w2WLoadingService.setLoaded()
        }
    }

    func tryToRestoreSubscriptionFromW2W() {
        let tryAmount = 3

        for _ in 1...tryAmount {
            Task {
                try await Task.sleep(seconds: 1)
                newSubscriptionService.restoreWithoutAppstore()
            }
        }
    }
}

private let userWithOnboardingApiKey = "AppStudio.userWithOnboardingApiKey"
extension CloudStorage {
    var userWithOnboardingApi: Bool {
        get { get(key: userWithOnboardingApiKey, defaultValue: false) }
        set { set(key: userWithOnboardingApiKey, value: newValue) }
    }
}
