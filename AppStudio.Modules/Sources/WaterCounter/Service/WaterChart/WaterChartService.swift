//  
//  WaterChartService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.03.2024.
//

import AppStudioModels
import Foundation

public protocol WaterChartService {
    func waterChartItems(for days: [Date]) async throws -> [HealthProgressBarChartItem]
    func waterHistoryChartItems(for days: [Date]) async throws -> [FastingHistoryChartItem]
    func waterUnits() async throws -> WaterUnits
}
