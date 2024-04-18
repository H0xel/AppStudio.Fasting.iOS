//  
//  WeightGoalWidgetInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import AppStudioModels
import Combine

public struct WeightGoalWidgetInput {
    let currentWeightPublisher: AnyPublisher<WeightMeasure, Never>

    public init(currentWeightPublisher: AnyPublisher<WeightMeasure, Never>) {
        self.currentWeightPublisher = currentWeightPublisher
    }
}
