//  
//  WeightChartService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

import AppStudioModels

protocol WeightChartService {
    func lastDaysItems(daysCount: Int) async throws -> [LineChartItem]
}
