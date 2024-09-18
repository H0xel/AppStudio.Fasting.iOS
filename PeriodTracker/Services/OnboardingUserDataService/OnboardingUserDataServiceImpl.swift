//  
//  OnboardingUserDataServiceImpl.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import MunicornFoundation
import Dependencies

class OnboardingUserDataServiceImpl: OnboardingUserDataService {
    @Dependency(\.cloudStorage) private var cloudStorage

    var onboardingUserData: OnboardingData?
    
    func save(_ data: OnboardingData) {
        cloudStorage.onboardingData = data
    }
    
    func reset() {
        cloudStorage.onboardingData = nil
    }
    
    
}


private let onboardingDataKey = "AppStudio.onboardingDataKey"
private extension CloudStorage {
    var onboardingData: OnboardingData? {
        get {
            let json: String? = get(key: onboardingDataKey)
            return try? OnboardingData(json: json ?? "")
        }

        set {
            set(key: onboardingDataKey, value: newValue.json())
        }
    }
}
