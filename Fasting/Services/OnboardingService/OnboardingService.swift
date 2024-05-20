//
//  OnboardingService.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

protocol OnboardingService {
    var data: OnboardingData? { get }
    var calculatedData: OnboardingCalculatedData? { get }
    var paywallInput: PersonalizedPaywallInput? { get }
    func save(data: OnboardingData)
    func reset()
}
