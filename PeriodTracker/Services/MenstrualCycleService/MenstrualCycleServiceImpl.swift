//  
//  MenstrualCycleServiceImpl.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//
import Foundation
import Dependencies

class MenstrualCycleServiceImpl: MenstrualCycleService {
    @Dependency(\.menstrualCalendarService) private var menstrualCalendarService

    func calculateCycles() async throws -> [MenstrualCycle] {
        let dates = try await menstrualCalendarService.dates()
        let cycles = groupMenstrualDates(dates)
        return cycles
    }

    func predictCyclesInFuture(from existedCycles: [MenstrualCycle]) async throws -> [MenstrualCycle] {
        predictMenstrualCycles(from: existedCycles, until: lastDayOfYear(yearsFromNow: 3))
    }
}

// MARK: - private functions
extension MenstrualCycleServiceImpl {
    // Функция для группировки дней в циклы
    private func groupMenstrualDates(_ dates: [Date]) -> [MenstrualCycle] {
        // Сортируем даты для правильного порядка
        let sortedDates = dates.sorted()
        var periods: [MenstrualCycle] = []

        // Переменные для хранения текущего цикла
        var currentCycleStartDate: Date?
        var currentCycleDates: [Date] = []

        // Функция для завершения текущего периода
        func finishCurrentCycle(nextCycleStartDate: Date?, forceLength: Int? = nil) {
            guard let startDate = currentCycleStartDate, !currentCycleDates.isEmpty else { return }

            var cycleLength: Int
            if let nextCycleStart = nextCycleStartDate {
                // Длина цикла — разница между началом текущего цикла и началом следующего
                cycleLength = Calendar.current.dateComponents([.day], 
                                                              from: startDate,
                                                              to: nextCycleStart).day ?? 0
            } else {
                // Если это последний цикл, используем фиксированную длину 28
                cycleLength = 28
            }

            // Если длина цикла больше 35, используем 28 для расчетов
            if cycleLength > 35 {
                cycleLength = 28
            }
            cycleLength = forceLength ?? cycleLength
            // Создаем период и добавляем в массив
            let period = MenstrualCycle(
                type: nextCycleStartDate == nil ? .current : .completed,
                startDate: startDate,
                otherDates: currentCycleDates,
                length: cycleLength
            )
            periods.append(period)
        }

        // Проходим по всем датам
        for date in sortedDates {
            if let lastDate = currentCycleDates.last {
                let daysDifference = Calendar.current.dateComponents([.day], 
                                                                     from: lastDate,
                                                                     to: date).day ?? 0

                // Если разница между датами больше 7 дней, начинаем новый цикл
                if daysDifference > 7 {
                    // Завершаем текущий цикл и начинаем новый
                    finishCurrentCycle(nextCycleStartDate: date)
                    currentCycleStartDate = date
                    currentCycleDates = [date]
                } else {
                    currentCycleDates.append(date)
                }
            } else {
                // Если это первая дата, инициализируем цикл
                currentCycleStartDate = date
                currentCycleDates = [date]
            }
        }
        let averageLength = averageCycleLength(cycles: periods)
        // Завершаем последний цикл (у него нет следующей даты, 
        // так что цикл будет иметь среднюю длину предыдущих циклов)
        finishCurrentCycle(nextCycleStartDate: nil, forceLength: averageLength)
        return periods
    }

    // Функция для расчета средней длины цикла
    private func averageCycleLength(cycles: [MenstrualCycle]) -> Int {
        guard !cycles.isEmpty else { return 28 }

        let totalLength = cycles.reduce(0) { $0 + $1.length }
        let averageLength =  Int(round(Double(totalLength) / Double(cycles.count)))
        return averageLength < 21 ? 21 : averageLength > 35 ? 35 : averageLength
    }

    // Функция для прогнозирования последующих циклов
    private func predictMenstrualCycles(from cycles: [MenstrualCycle], until targetDate: Date) -> [MenstrualCycle] {
        guard let lastCycle = cycles.last else { return [] }

        let averageLength = Int(averageCycleLength(cycles: cycles))
        var predictedCycles: [MenstrualCycle] = []
        var currentStartDate = lastCycle.startDate

        while currentStartDate < targetDate {
            let nextStartDate = Calendar.current.date(byAdding: .day,
                                                      value: averageLength,
                                                      to: currentStartDate) ?? .now
            if nextStartDate > targetDate {
                break
            }

            let predictedCycle = MenstrualCycle(
                type: .predicted,
                startDate: nextStartDate,
                otherDates: [],
                length: averageLength
            )
            predictedCycles.append(predictedCycle)
            currentStartDate = nextStartDate
        }

        return predictedCycles
    }

    private func lastDayOfYear(yearsFromNow: Int) -> Date {
        let calendar = Calendar.current

        // Определяем текущий год
        let currentYear = calendar.component(.year, from: Date())

        // Рассчитываем нужный год, добавляя количество лет
        let targetYear = currentYear + yearsFromNow - 1

        // Определяем дату 31 декабря целевого года
        var components = DateComponents()
        components.year = targetYear
        components.month = 12
        components.day = 31

        return calendar.date(from: components)?.dayDate ?? .now
    }
}
