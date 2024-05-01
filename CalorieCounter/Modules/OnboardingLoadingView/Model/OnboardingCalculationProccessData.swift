//
//  OnboardingCalculationProccessData.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import Foundation

struct OnboardingCalculationProccessData: Equatable {
    let angle: CGFloat
    let progress: CGFloat
    let phase: OnboardingCalculationProccessPhases

    static func calculateData(
        interval: CGFloat,
        params: OnboardingCalculationProccessParameters = .defaultParameters
    ) -> OnboardingCalculationProccessData {

        let angle = interval.scale(from: params.intervalRange, to: params.rotationAngleRange)
        let progress = interval.scale(from: params.intervalRange, to: 0 ... 1.0)

        let phase: OnboardingCalculationProccessPhases =
        switch progress {
        case 0 ..< 0.2: .phase1
        case 0.2 ..< 0.6: .phase2
        case 0.6 ..< 0.9: .phase3
        default: .phase4
        }

        return .init(angle: -1 * angle, progress: progress, phase: phase)
    }
}
