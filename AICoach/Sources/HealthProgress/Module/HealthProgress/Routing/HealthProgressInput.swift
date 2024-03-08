//  
//  HealthProgressInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

public struct FastingHealthProgressInput {
    let bodyMassIndex: Double
    let fastingChartItems: [HealthProgressBarChartItem]

    public init(bodyMassIndex: Double, fastingChartItems: [HealthProgressBarChartItem]) {
        self.bodyMassIndex = bodyMassIndex
        self.fastingChartItems = fastingChartItems
    }
}

public extension FastingHealthProgressInput {
    static var empty: FastingHealthProgressInput {
        .init(bodyMassIndex: 0, fastingChartItems: [])
    }
}
