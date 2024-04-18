//
//  WeightProgressChartService.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import Foundation
import AppStudioModels

protocol WeightProgressChartService {
    func configureChartItems(from history: [WeightHistory],
                             chartScale: DateChartScale) -> [WeightLineType: LineChartItem]
    func configureWeightGoalItems(for history: [WeightHistory],
                                  chartScale: DateChartScale) async throws -> LineChartItem
    func hiddenLayer(scale: DateChartScale, values: [LineChartValue]) -> LineChartItem
}
