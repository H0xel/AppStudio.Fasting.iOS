//  
//  SetupFastingInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

struct SetupFastingInput {
    enum Context {
        case onboarding
        case mainScreen
        case profile
    }

    let plan: FastingPlan
    let context: Context
}

extension SetupFastingInput.Context {
    init(_ context: ChooseFastingPlanInput.Context) {
        switch context {
        case .onboarding: self = .onboarding
        case .mainScreen: self = .mainScreen
        case .profile: self = .profile
        }
    }
}
