//  
//  WeightProgressViewModel.swift
//  FastingTests
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioModels
import Dependencies
import Combine

class WeightProgressViewModel: BaseViewModel<WeightProgressOutput> {

    @Dependency(\.weightService) private var weightService
    @Dependency(\.weightProgressChartService) private var weightProgressChartService

    var router: WeightProgressRouter!
    @Published var chartScale: DateChartScale = .week
    @Published var startDate: Date = .now.startOfTheDay.add(days: -6)
    @Published var selectedDate: Date?
    private var weightHistoryObserver: WeightHistoryObserver?
    let weightUnits: WeightUnit
    @Published private var charts: [WeightLineType: LineChartItem] = [:]
    private let weightHistorySubject = CurrentValueSubject<[WeightHistory], Never>([])
    lazy var scaleWeightHistoryViewModel: ScaleWeightHistoryViewModel = {
        .init(weightPublisher: weightHistorySubject.eraseToAnyPublisher(), 
              weightUnits: weightUnits,
              router: .init(navigator: router.navigator))
    }()

    init(input: WeightProgressInput, output: @escaping WeightProgressOutputBlock) {
        weightUnits = input.weightUnits
        super.init(output: output)
        observeChartScale()
        observeHistory()
        observeStartDate()
    }

    var chartItems: [LineChartItem] {
        [charts[.scaleWeight], charts[.trueWeight], charts[.weightGoal], charts[.hidden]].compactMap { $0 }
    }

    var annotationItems: [LineChartItem] {
        [charts[.trueWeight], charts[.scaleWeight], charts[.weightGoal]].compactMap { $0 }
    }

    var endDate: Date {
        startDate.add(days: chartScale.numberOfDays - 1)
    }

    var minDate: Date {
        if let item = charts[.trueWeight]?.values.first {
            return item.label
        }
        return .now.startOfTheDay
    }

    var currentTrueWeight: WeightMeasure {
        guard let last = charts[.trueWeight]?.values.last else {
            return .init(value: 0, units: weightUnits)
        }
        return .init(value: last.value, units: weightUnits)
    }

    var weeklyChanges: Double? {
        let values = Array(charts[.trueWeight]?.values.suffix(21) ?? [])
        guard values.count == 21 else {
            return nil
        }
        let firstWeek = values[0...6]
        let firstWeekDifference = (firstWeek.last?.value ?? 0) - (firstWeek.first?.value ?? 0)
        let secondWeek = values[7...13]
        let secondWeekDiffrence = (secondWeek.last?.value ?? 0) - (secondWeek.first?.value ?? 0)
        let thirdWeek = values[14...20]
        let thirdWeekDiffrence = (thirdWeek.last?.value ?? 0) - (thirdWeek.first?.value ?? 0)
        return (firstWeekDifference + secondWeekDiffrence + thirdWeekDiffrence) / 3
    }

    var weightProjection: Double? {
        guard let weeklyChanges else {
            return nil
        }
        return currentTrueWeight.value + (4 * weeklyChanges)
    }

    var averageWeight: WeightMeasure {
        let items = filteredItems(of: .trueWeight)
        guard !items.isEmpty else {
            return .init(value: 0, units: weightUnits)
        }
        let weight = items.reduce(0) { $0 + $1.value }
        return .init(value: weight / Double(items.count), units: weightUnits)
    }

    var changeOverPeriod: WeightMeasure {
        let items = filteredItems(of: .trueWeight)
        guard let first = items.first,
              let last = items.last else {
            return .init(value: 0, units: weightUnits)
        }
        let difference = last.value - first.value 
        return .init(value: difference, units: weightUnits)
    }

    var selectedDateScaleWeight: WeightMeasure? {
        guard let selectedDate else {
            return nil
        }
        let item = charts[.scaleWeight]
        guard let selectedItem = item?.values.first(where: {
            $0.label.startOfTheDay == selectedDate.startOfTheDay
        }) else {
            return nil
        }
        return .init(value: selectedItem.value, units: weightUnits)
    }

    var selectedDateTrueWeight: WeightMeasure? {
        guard let selectedDate else {
            return nil
        }
        let item = charts[.trueWeight]
        guard let selectedItem = item?.values.first(where: {
            $0.label.startOfTheDay == selectedDate.startOfTheDay
        }) else {
            return nil
        }
        return .init(value: selectedItem.value, units: weightUnits)
    }

    func closeSelectedView() {
        selectedDate = nil
    }

    func handle(weightProgressWeightOutput output: WeightProgressWeightOutput) {
        switch output {
        case .prevTap:
            showPrevPeriod()
        case .nextTap:
            showNextPeriod()
        case .titleTap:
            resetStartDate(for: chartScale)
        }
    }

    func toggleVisibility(of item: LineChartItem) {
        guard let key = charts.first(where: { $0.value.id == item.id })?.key else {
            return
        }
        charts[key] = item.currentLineWidth == 0 ? item.visible : item.invisible
    }

    private func resetStartDate(for scale: DateChartScale) {
        startDate = .now.startOfTheDay.add(days: -(scale.numberOfDays - 1))
    }

    private func showPrevPeriod() {
        let minDate = minDate
        guard startDate > minDate else {
            return
        }
        startDate = max(startDate.add(days: -(chartScale.numberOfDays)), minDate)
    }

    private func showNextPeriod() {
        guard endDate.startOfTheDay < .now.startOfTheDay else {
            return
        }
        startDate = min(
            endDate.add(days: 1).startOfTheDay,
            .now.startOfTheDay.add(days: -(chartScale.numberOfDays - 1))
        )
    }

    private func filteredItems(of type: WeightLineType) -> [LineChartValue] {
        guard let chartItems = charts[type]?.values else {
            return []
        }
        return chartItems.filter { $0.label >= startDate.startOfTheDay && $0.label <= endDate.startOfTheDay  }
    }

    private func observeChartScale() {
        $chartScale
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scale in
                guard let self else { return }
                self.resetStartDate(for: scale)
                self.charts[.hidden] = weightProgressChartService.hiddenLayer(
                    scale: scale,
                    values: charts[.trueWeight]?.values ?? []
                )
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.resetStartDate(for: scale)
                }
            }
            .store(in: &cancellables)
    }

    private func observeHistory() {
        weightHistoryObserver = weightService.weightHistoryObserver()

        weightHistoryObserver?.results
            .sink { [weak self] history in
                self?.output(.weightUpdated)
                self?.weightHistorySubject.send(history)
                self?.configureChartItems(from: history)
            }
            .store(in: &cancellables)
    }

    private func configureChartItems(from history: [WeightHistory]) {
        Task {
            let items = weightProgressChartService.configureChartItems(from: history, chartScale: chartScale)
            await MainActor.run {
                charts = items
            }
            let chartGoalItem = try await weightProgressChartService.configureWeightGoalItems(
                for: history,
                chartScale: chartScale
            )
            await MainActor.run {
                charts[.weightGoal] = chartGoalItem
            }
        }
    }

    private func observeStartDate() {
        $startDate
            .sink { [weak self] date in
                guard let self else { return }
                if let selectedDate, selectedDate < date || selectedDate > date.add(days: chartScale.numberOfDays-1) {
                    self.selectedDate = nil
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Routing
extension WeightProgressViewModel {
    func dismiss() {
        router.dismiss()
    }

    func presentInfo() {
        router.presentWeightHint()
    }
}
