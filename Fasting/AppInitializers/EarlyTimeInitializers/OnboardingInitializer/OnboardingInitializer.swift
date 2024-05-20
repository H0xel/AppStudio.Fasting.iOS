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

    func initialize() {
        Task {
            let onboardingResponse = try await onboardingApi.onboarding(.init(clientEmail: nil))
            if let onboardingData = onboardingResponse.onboarding, !cloudStorage.userWithOnboardingApi {
                userPropertyService.set(userProperties: ["w2w": true])
                onboardingService.save(data: .init(onboardingData))
                cloudStorage.userWithOnboardingApi = true
            }
        }
    }
}

private let userWithOnboardingApiKey = "AppStudio.userWithOnboardingApiKey"
extension CloudStorage {
    var userWithOnboardingApi: Bool {
        set { set(key: userWithOnboardingApiKey, value: newValue) }
        get { get(key: userWithOnboardingApiKey, defaultValue: false) }
    }
}
