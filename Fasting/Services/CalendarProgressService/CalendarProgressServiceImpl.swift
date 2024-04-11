//
//  CalendarProgressServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 12.03.2024.
//

import Foundation
import HealthOverview
import AppStudioModels
import Dependencies
import Combine

class CalendarProgressServiceImpl: CalendarProgressService {

    private var historyObserver: FastingIntervalHistoryObserver?

    @Dependency(\.fastingHistoryService) private var fastingHistoryService

    var historyPublisher: AnyPublisher<[Date: DayProgress], Never> {
        let observer = fastingHistoryService.historyObserver
        historyObserver = observer
        return observer.results
            .map { results in
                results.reduce([Date: DayProgress]()) {
                    var result = $0
                    let history = $1
                    let progress = DayProgress(
                        goal: history.plan.duration,
                        result: history.finishedDate.timeIntervalSince(history.startedDate)
                    )
                    result[history.startedDate.startOfTheDay] = progress
                    return result
                }
            }
            .eraseToAnyPublisher()
    }
}
