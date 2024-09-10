//
//  MenstrualCycle.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//

import Foundation

///
/// - Parameters:
///     - startDate: Первый день цикла
///     - otherDates: Другие выделенные дни цикла
///     - length: Длина полного цикла
///     - ovulationDay: День овуляции
///     - fertileDaysBeforeOvulation: Количество благоприятных дней перед овуляцией
///     - fertileDaysAfterOvulation: Количество благоприятных дней после овуляции
struct MenstrualCycle: Codable {
    let type: MenstrualCycleType
    let startDate: Date
    let otherDates: [Date]
    let length: Int
}

// MARK: - расчет дня овуляции и благоприятных дней
// TODO: - нужно сделать правильный расчет, в зависимости от длины цикла
extension MenstrualCycle {
    var ovulationDay: Int {
        length - 14
    }
    var fertileDaysBeforeOvulation: Int {
        5
    }
    var fertileDaysAfterOvulation: Int {
        1
    }
}
