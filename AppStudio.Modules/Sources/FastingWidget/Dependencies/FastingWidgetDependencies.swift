//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation
import Dependencies
import AppStudioModels

extension DependencyValues {
    var fastingWidgetService: FastingWidgetService {
        self[FastingWidgetServiceKey.self]!
    }
}

enum FastingWidgetServiceKey: DependencyKey {
    public static var liveValue: FastingWidgetService?
    public static var testValue: FastingWidgetService? = FastingWidgetServiceImpl()
    public static var previewValue: FastingWidgetService? = FastingWidgetServiceImpl()
}

private class FastingWidgetServiceImpl: FastingWidgetService {
    func fastingState(for weeks: [Week]) async throws -> [Date : FinishedFastingWidgetState] {
        [:]
    }
}

