//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation
import AppStudioUI
import AppStudioModels
import AppStudioNavigation
import Dependencies
import AppStudioServices
import MunicornFoundation
import Combine

private let shouldPresentWeightWidgetHintKey = "shouldPresentWeightWidgetHintKey"

public class WeightWidgetViewModel: BaseViewModel<WeightWidgetOutput> {

    @Dependency(\.storageService) private var storageService
    @Dependency(\.weightService) private var weightService
    @Dependency(\.trueWeightCalculationService) private var trueWeightCalculationService
    @Dependency(\.trackerService) private var trackerService

    @Published var isHintPresented = true
    @Published private var weightHistory: [Date: WeightHistory] = [:]
    @Published private var currentDate: Date = .now.beginningOfDay
    private var router: WeightWidgetRouter!
    private var units: WeightUnit = .kg

    public override init() {
        super.init()
        isHintPresented = storageService.shouldPresentWeightWidgetHint
    }

    func weight(for day: Date) -> WeightMeasure? {
        weightHistory[day]?.scaleWeight
    }

    func trueWeight(for day: Date) -> WeightMeasure? {
        weightHistory[day]?.trueWeight
    }

    public func initialize(navigator: Navigator,
                           currentDatePublisher: Published<Date>.Publisher,
                           units: WeightUnit,
                           output: @escaping ViewOutput<WeightWidgetOutput>) {
        self.units = units
        router = .init(navigator: navigator)
        super.initialize(output: output)
        currentDatePublisher
            .assign(to: &$currentDate)
    }

    public func loadData(for weeks: [Week]) {
        Task {
            let history = try await weightService.history(for: weeks)
            var currentHistory = weightHistory
            for (day, history) in history {
                currentHistory[day] = history
            }
            await updateHistory(currentHistory)
        }
    }

    func presentHint(source: String) {
        trackTapInfo(source: source)
        router.presentHint()
    }

    func updateWeight() {
        trackerService.track(.tapUpdateWeight(date: currentDate.description,
                                              today: currentDate.beginningOfDay == .now.beginningOfDay))
        router.presentWeightUpdate(input: .init(date: currentDate, units: units)) { [weak self] output in
            guard let self else { return }
            switch output {
            case .weightUpdated(let history):
                self.loadData(for: [.init(ofDay: self.currentDate)])
                self.updateTrueWeightIfNeeded(history: history)
                self.trackerService.track(.weightUpdated(date: history.historyDate.description))
            }
        }
    }

    func hideHint() {
        storageService.shouldPresentWeightWidgetHint = false
        isHintPresented = false
    }

    @MainActor
    private func updateHistory(_ history: [Date: WeightHistory]) {
        weightHistory = history
    }

    private func updateTrueWeightIfNeeded(history: WeightHistory) {
        guard history.historyDate < .now.beginningOfDay else {
            return
        }
        Task {
            try await weightService.updateTrueWeight(after: history.historyDate.add(days: 1))
            loadData(for: [.init(ofDay: self.currentDate)])
        }
    }
}

private extension StorageService {
    var shouldPresentWeightWidgetHint: Bool {
        get { get(key: shouldPresentWeightWidgetHintKey, defaultValue: true) }
        set { set(key: shouldPresentWeightWidgetHintKey, value: newValue) }
    }
}

private extension WeightWidgetViewModel {
    func trackTapInfo(source: String) {
        trackerService.track(.tapInfo(context: "daily", source: source, target: "weight"))
    }
}
