//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 08.03.2024.
//

import Foundation
import Dependencies
import Combine
import AppStudioModels

extension DependencyValues {
    var calendarProgressService: CalendarProgressService {
        self[CalendarProgressServiceKey.self]!
    }
}

enum CalendarProgressServiceKey: DependencyKey {
    static var liveValue: CalendarProgressService?
    static var testValue: CalendarProgressService? = CalendarProgressServiceImpl()
    static var previewValue: CalendarProgressService? = CalendarProgressServiceImpl()
}

private class CalendarProgressServiceImpl: CalendarProgressService {
    var historyPublisher: AnyPublisher<[Date : DayProgress], Never> {
        Just([:]).eraseToAnyPublisher()
    }
}
