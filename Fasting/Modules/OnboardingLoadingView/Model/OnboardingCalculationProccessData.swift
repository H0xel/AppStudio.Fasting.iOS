//
//  OnboardingCalculationProccessData.swift
//  Fasting
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
        let phases = OnboardingCalculationProccessPhases.allCases
        let phasesRange = 0.0 ... CGFloat(phases.count)
        var index = Int( interval.scale(from: params.intervalRange, to: phasesRange))

        index = index > phases.count - 1 ? phases.count - 1 : index

        return .init(angle: -1 * angle, progress: progress, phase: OnboardingCalculationProccessPhases.allCases[index])
    }
}
