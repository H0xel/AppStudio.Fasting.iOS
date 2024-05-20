//
//  OnboardingInitializerDependency.swift
//  Fasting
//
//  Created by Amakhin Ivan on 15.05.2024.
//

import Dependencies

extension DependencyValues {
    var onboardingInitializer: AppInitializer {
        self[OnboardingInitializerKey.self]
    }
}

private enum OnboardingInitializerKey: DependencyKey {
    static let liveValue: AppInitializer = OnboardingInitializer()
}
