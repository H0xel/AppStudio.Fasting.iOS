//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 12.03.2024.
//

import Foundation
import AppStudioModels
import Combine

public protocol CalendarProgressService {
    var historyPublisher: AnyPublisher<[Date: DayProgress], Never> { get }
}

class CalendarProgressServiceMock: CalendarProgressService {
    var historyPublisher: AnyPublisher<[Date: DayProgress], Never> {
        Just([
            .now: .init(goal: 12, result: 1)
        ])
        .eraseToAnyPublisher()
    }
}
