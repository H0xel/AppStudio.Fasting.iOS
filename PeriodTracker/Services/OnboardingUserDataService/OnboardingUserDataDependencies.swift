//  
//  OnboardingUserDataDependencies.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import Dependencies

extension DependencyValues {
    var onboardingUserDataService: OnboardingUserDataService {
        self[OnboardingUserDataServiceKey.self]
    }
}

private enum OnboardingUserDataServiceKey: DependencyKey {
    static var liveValue: OnboardingUserDataService = OnboardingUserDataServiceImpl()
    static var testValue: OnboardingUserDataService = OnboardingUserDataServiceImpl()
    static var previewValue: OnboardingUserDataService = OnboardingUserDataServiceImpl()
}
