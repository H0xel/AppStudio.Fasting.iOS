//  
//  ChooseFastingPlanInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

struct ChooseFastingPlanInput {
    enum Context: String {
        case onboarding
        case fasting
        case profile
        case daily
    }
    let context: Context
}
