//
//  MenstrualCycleType.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 10.09.2024.
//

import Foundation
/// MenstrualCycleType
/// - Parameters:
///  - completed: цикл завершен и залогирован пользователем
///  - predicted: цикл рассчитан пользователем
enum MenstrualCycleType: String, Codable {
    case completed
    case predicted
    case current
}
