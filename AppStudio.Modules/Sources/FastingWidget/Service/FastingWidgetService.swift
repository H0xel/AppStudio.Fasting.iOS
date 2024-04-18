//
//  FastingProgressService.swift
//
//
//  Created by Руслан Сафаргалеев on 08.03.2024.
//

import Foundation
import AppStudioModels

public protocol FastingWidgetService {
    func fastingState(for weeks: [Week]) async throws -> [Date: FinishedFastingWidgetState]
}

class FastingWidgetServiceMock: FastingWidgetService {
    func fastingState(for weeks: [AppStudioModels.Week]) async throws -> [Date : FinishedFastingWidgetState] {
        [
            .now : .mockFinished
        ]
    }
}
