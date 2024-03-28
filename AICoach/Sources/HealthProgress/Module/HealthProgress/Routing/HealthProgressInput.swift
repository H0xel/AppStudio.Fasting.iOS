//  
//  HealthProgressInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import AppStudioModels

public struct FastingHealthProgressInput {
    public let bodyMassIndex: Double
    let weightUnits: WeightUnit
    let fastingChartItems: [HealthProgressBarChartItem]

    public init(bodyMassIndex: Double,
                weightUnits: WeightUnit,
                fastingChartItems: [HealthProgressBarChartItem]) {
        self.bodyMassIndex = bodyMassIndex
        self.fastingChartItems = fastingChartItems
        self.weightUnits = weightUnits
    }
}

public extension FastingHealthProgressInput {
    static var empty: FastingHealthProgressInput {
        .init(bodyMassIndex: 0, weightUnits: .kg, fastingChartItems: [])
    }
}
