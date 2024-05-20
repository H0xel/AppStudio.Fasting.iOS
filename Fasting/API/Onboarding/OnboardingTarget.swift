//
//  OnboardingTarget.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.05.2024.
//

import Foundation
import Moya

enum OnboardingTarget {
    case onboarding(PostOnboardingRequest)
}

extension OnboardingTarget: TelecomTargetType {

    var path: String {
        switch self {
        case .onboarding:
            "fasting/onboarding"
        }
    }

    var method: Moya.Method {
        .put
    }

    var task: Moya.Task {
        switch self {
        case .onboarding(let onboarding):
                .requestJSONEncodable(onboarding)
        }
    }
}
