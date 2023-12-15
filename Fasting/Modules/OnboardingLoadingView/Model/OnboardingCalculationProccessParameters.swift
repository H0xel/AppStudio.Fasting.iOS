//
//  OnboardingCalculationProccessParameters.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import Foundation

struct OnboardingCalculationProccessParameters {
    let rotationAngleRange: ClosedRange<CGFloat>
    let totalInterval: CGFloat
    let intervalPerPhase: CGFloat
    let intervalRange: ClosedRange<CGFloat>

    init(rotationAngleRange: ClosedRange<CGFloat>,
         totalInterval: CGFloat) {
        self.rotationAngleRange = rotationAngleRange
        self.totalInterval = totalInterval
        self.intervalPerPhase = totalInterval / CGFloat(OnboardingCalculationProccessPhases.allCases.count)
        self.intervalRange = 0 ... totalInterval
    }

    static let defaultParameters: OnboardingCalculationProccessParameters = .init(
        rotationAngleRange: 5 ... 360,
        totalInterval: 18.0
    )
}
