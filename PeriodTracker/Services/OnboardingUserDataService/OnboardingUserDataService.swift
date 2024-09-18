//  
//  OnboardingUserDataService.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

protocol OnboardingUserDataService {
    var onboardingUserData: OnboardingData? { get }
    func save(_ data: OnboardingData)
    func reset()
}
