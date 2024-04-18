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
    let fastingHistoryChartItems: [FastingHistoryChartItem]
    let fastingHistoryData: FastingHistoryData

    public init(bodyMassIndex: Double,
                weightUnits: WeightUnit,
                fastingChartItems: [HealthProgressBarChartItem],
                fastingHistoryChartItems: [FastingHistoryChartItem],
                fastingHistoryData: FastingHistoryData) {
        self.bodyMassIndex = bodyMassIndex
        self.weightUnits = weightUnits
        self.fastingChartItems = fastingChartItems
        self.fastingHistoryChartItems = fastingHistoryChartItems
        self.fastingHistoryData = fastingHistoryData
    }
}

public extension FastingHealthProgressInput {
    static var empty: FastingHealthProgressInput {
        .init(bodyMassIndex: 0, weightUnits: .kg, fastingChartItems: [], fastingHistoryChartItems: [], fastingHistoryData: .init(records: []))
    }
}
