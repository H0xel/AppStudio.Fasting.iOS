//
//  FastingProgressServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.03.2024.
//

import Foundation
import HealthOverview
import AppStudioModels
import Dependencies
import FastingWidget

class FastingWidgetServiceImpl: FastingWidgetService {

    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.fastingParametersService) private var fastingParametersService

    func fastingState(for weeks: [Week]) async throws -> [Date: FinishedFastingWidgetState] {
        let days = weeks.flatMap { $0.days }
        let history = try await fastingHistoryService.history(for: days)
        var result: [Date: FinishedFastingWidgetState] = [:]
        for day in days {
            if let dayHistory = history[day] {
                result[day] = .init(
                    fastingId: dayHistory.id,
                    startDate: dayHistory.startedDate,
                    finishedDate: dayHistory.finishedDate,
                    finishPhase: dayHistory.stage
                )
            } else {
                result[day] = .init(fastingId: nil,
                                    startDate: day,
                                    finishedDate: day,
                                    finishPhase: nil)
            }
        }
        return result
    }
}
