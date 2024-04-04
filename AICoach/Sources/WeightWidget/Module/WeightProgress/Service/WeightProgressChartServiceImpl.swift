//
//  WeightProgressChartService.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import Foundation
import Dependencies
import AppStudioModels
import WeightGoalWidget

class WeightProgressChartServiceImpl: WeightProgressChartService {

    @Dependency(\.weightInterpolationService) private var weightInterpolationService
    @Dependency(\.weightGoalService) private var weightGoalService

    func configureChartItems(
        from history: [WeightHistory],
        chartScale: DateChartScale
    ) -> [WeightLineType: LineChartItem] {
        var result: [WeightLineType: LineChartItem] = [:]
        let interpolatedHistory = interpolatedHistory(from: history, chartScale: chartScale)
        result[.scaleWeight] = scaleWeightItem(from: interpolatedHistory)
        result[.trueWeight] = trueWeightItem(from: interpolatedHistory)
        result[.hidden] = hiddenLayer(scale: chartScale, values: result[.trueWeight]?.values ?? [])
        return result
    }

    func configureWeightGoalItems(
        for history: [WeightHistory],
        chartScale: DateChartScale
    ) async throws -> LineChartItem {
        let history = interpolatedHistory(from: history, chartScale: chartScale)
        let goals = try await weightGoalService.goals()
        var datedGoals: [Date: WeightGoal] = [:]
        goals.forEach { goal in
            datedGoals[goal.dateCreated.beginningOfDay] = goal
        }
        let sortedGoals = datedGoals.sorted(by: { $0.key < $1.key }).map { $0.value }
        guard let first = sortedGoals.first else { return .weightGoal(values: [], color: .studioBlackLight) }
        let values = history.map { history in
            LineChartValue(
                value: sortedGoals.last(where: {
                    $0.dateCreated.beginningOfDay <= history.historyDate
                })?.goal ?? first.goal,
                label: history.historyDate
            )
        }
        return .weightGoal(values: values, color: .studioBlackLight)
    }

    func hiddenLayer(scale: DateChartScale, values: [LineChartValue]) -> LineChartItem {
        let startDate = Date().add(days: -(scale.numberOfDays-1)).beginningOfDay
        guard let first = values.first,
              let last = values.last else {
            return .hidden(values: [])
        }
        let difference = last.label.timeIntervalSince(first.label) / .second
        guard difference < Double(scale.visibleDomain) else {
            return .hidden(values: [])
        }
        let days = (0 ..< scale.numberOfDays).map { startDate.add(days: $0) }
        return .hidden(values: days.map { .init(value: first.value, label: $0) })
    }

    private func scaleWeightItem(from history: [WeightHistory]) -> LineChartItem {
        let scaleWeightItems = history.map {
            LineChartValue(value: $0.scaleWeightValue, label: $0.historyDate)
        }
        return .scaleWeight(values: scaleWeightItems, color: .studioGreyStrokeFill)
    }

    private func trueWeightItem(from history: [WeightHistory]) -> LineChartItem {
        let trueWeightItems = history.map {
            LineChartValue(value: $0.trueWeightValue, label: $0.historyDate)
        }
        return .trueWeight(values: trueWeightItems, color: .studioBlue)
    }

    private func interpolatedHistory(from history: [WeightHistory],
                                     chartScale: DateChartScale) -> [WeightHistory] {
        guard let last = history.last else {
            return []
        }
        if history.count == 1 {
            return historyForSingleItem(history: last, scale: chartScale)
        }
        var history = history
        if last.historyDate != .now.beginningOfDay {
            let todayHistory = last.updated(historyDate: .now.beginningOfDay)
            history.append(todayHistory)
        }
        return weightInterpolationService.interpolate(weightHistory: history)
    }

    private func historyForSingleItem(history: WeightHistory, scale: DateChartScale) -> [WeightHistory] {
        let value = Int(max(Date().timeIntervalSince(history.historyDate) / .day, Double(scale.numberOfDays)))
        return (0 ..< value).map { history.updated(historyDate: .now.add(days: -$0).beginningOfDay) }.reversed()
    }
}
