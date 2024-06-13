//  
//  SetupFastingInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

struct SetupFastingInput {
    enum Context: String {
        case onboarding
        case fasting
        case profile
        case daily
    }

    let plan: FastingPlan
    let context: Context
}

extension SetupFastingInput.Context {
    init(_ context: ChooseFastingPlanInput.Context) {
        switch context {
        case .onboarding, .w2wOnboarding: self = .onboarding
        case .fasting: self = .fasting
        case .profile: self = .profile
        case .daily: self = .daily
        }
    }
}

extension ChooseFastingPlanInput.Context {
    init(_ context: SetupFastingInput.Context) {
        switch context {
        case .onboarding: self = .onboarding
        case .fasting: self = .fasting
        case .profile: self = .profile
        case .daily: self = .daily
        }
    }
}
