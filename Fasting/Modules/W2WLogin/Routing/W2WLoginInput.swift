//  
//  W2WLoginInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.06.2024.
//

struct W2WLoginInput {
    let context: Context
}

extension W2WLoginInput {
    enum Context {
        case onboarding
        case settings
    }
}
