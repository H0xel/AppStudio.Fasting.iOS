//
//  OnboardingServiceDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

import Dependencies

extension DependencyValues {
    var onboardingService: OnboardingService {
        self[OnboardingServiceKey.self]
    }
}

private enum OnboardingServiceKey: DependencyKey {
    static var liveValue: OnboardingService = OnboardingServiceImpl()
    static var testValue: OnboardingService = OnboardingServiceImpl()
}
