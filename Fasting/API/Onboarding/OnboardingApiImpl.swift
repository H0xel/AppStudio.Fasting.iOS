//
//  OnboardingApiImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.05.2024.
//

import Moya
import Foundation
import Dependencies
import AppStudioFoundation

class OnboardingApiImpl: OnboardingApi {

    private let provider = TelecomApiProvider<OnboardingTarget>()

    func onboarding(_ onboarding: PostOnboardingRequest) async throws -> OnboardingResponse {
        try await provider.request(.onboarding(onboarding))
    }
}
