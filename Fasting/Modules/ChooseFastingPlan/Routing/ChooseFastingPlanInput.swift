//  
//  ChooseFastingPlanInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

struct ChooseFastingPlanInput {
    enum Context {
        case onboarding
        case mainScreen
        case profile
    }
    let context: Context
}
