//
//  OnboardingApi.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.05.2024.
//

import Foundation

protocol OnboardingApi {
    func onboarding(_ onboarding: PostOnboardingRequest) async throws -> OnboardingResponse
}
