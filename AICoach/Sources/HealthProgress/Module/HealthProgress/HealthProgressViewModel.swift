//  
//  HealthProgressViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Combine
import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import AppStudioServices
import AppStudioModels
import WeightGoalWidget
import WeightWidget
import WaterCounter

private let isBodyMassIndexHintPresentedKey = "isBodyMassIndexHintPresented"
private let isWeightHintPresentedKey = "HealthProgress.isWeightWeightWidgetHintPresentedKey"

class HealthProgressViewModel: BaseViewModel<HealthProgressOutput> {

    @Dependency(\.storageService) private var storageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.weightChartService) private var weightChartService
    @Dependency(\.weightService) private var weightService
    @Dependency(\.waterChartService) private var waterChartService

    var router: HealthProgressRouter!
    @Published var isBodyMassHintPresented = true
    @Published var isWeightHintPresented = true
    @Published var bodyMassIndex: Double = 0
    @Published var fastingChartItems: [HealthProgressBarChartItem] = []
    @Published var waterChartItems: [HealthProgressBarChartItem] = []
    @Published var weightChartItems: [LineChartItem] = []
    private let currentWeightSubject = CurrentValueSubject<WeightMeasure, Never>(.init(value: 0))
    private var inputCancellable: AnyCancellable?
    private var defaultWeightUnits: WeightUnit = .lb

    init(inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
         output: @escaping HealthProgressOutputBlock) {
        super.init(output: output)
        observeInput(inputPublisher: inputPublisher)
        isBodyMassHintPresented = storageService.isBodyMassIndexHintPresented
        isWeightHintPresented = storageService.isWeightHintPresented
    }

    var weightGoalRoute: Route {
        WeightGoalWidgetRoute(
            navigator: router.navigator,
            input: .init(currentWeightPublisher: currentWeightSubject.eraseToAnyPublisher()),
            output: { _ in }
        )
    }

    func closeBodyMassIndexHint() {
        isBodyMassHintPresented = false
        storageService.isBodyMassIndexHintPresented = false
    }

    func closeWeightHint() {
        isWeightHintPresented = false
        storageService.isWeightHintPresented = false
    }

    func handleFastingWidgetOutput(output: HealthChartOutput) {
        switch output {
        case .infoTap:
            presentFastingInfo()
        case .learnMoreTap:
            trackTapInfo(source: "learn_more", target: "fasting")
        case .emptyStateButtonTap:
            break
        }
    }

    func handleWeightWidgetOutput(output: HealthChartOutput) {
        switch output {
        case .infoTap:
            presentWeightInfo(source: "info")
        case .learnMoreTap:
            exploreWeight()
        case .emptyStateButtonTap:
            presentUpdateWeight()
        }
    }

    func handleWaterWidgetOutput(output: HealthChartOutput) {
        switch output {
        case .infoTap:
            presentWaterSettings()
        case .learnMoreTap:
            break
        case .emptyStateButtonTap:
            break
        }
    }

    func presentBodyMassIndexInfo(source: String) {
        trackTapInfo(source: source, target: "bmi")
        router.presentBodyMassIndexHint(bodyMassIndex: bodyMassIndex.bodyMassIndex) { [weak self] question in
            self?.output(.novaQuestion(question))
        }
    }

    func updateWeight() {
        Task {
            async let items = weightChartService.lastDaysItems(daysCount: 7)
            async let weight = weightService.history(byDate: .now)
            try await updateWeight(chartItems: items, currentWeight: weight)
        }
    }

    func updateWater() {
        Task {
            let dates = (0 ..< 7).map { Date.now.beginningOfDay.adding(.day, value: -$0) }.reversed()
            let items = try await waterChartService.waterChartItems(for: Array(dates))
            await MainActor.run {
                waterChartItems = items
            }
        }
    }

    private func observeInput(inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>) {
        inputCancellable = inputPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                self?.bodyMassIndex = input.bodyMassIndex
                self?.fastingChartItems = input.fastingChartItems
                self?.defaultWeightUnits = input.weightUnits
            }
    }

    func presentWeightInfo(source: String) {
        trackTapInfo(source: source, target: "weight")
        router.presentWeightHint()
    }

    func presentFastingInfo() {
        trackTapInfo(source: "info", target: "fasting")
        router.presentFastingHint { [weak self] question in
            self?.output(.novaQuestion(question))
        }
    }

    private func presentUpdateWeight() {
        router.presentUpdateWeight(units: defaultWeightUnits) { [weak self] output in
            switch output {
            case .weightUpdated:
                self?.updateWeight()
            }
        }
    }

    private func presentWaterSettings() {
        trackerService.track(.tapWaterSettings(context: "progress"))
        router.presentWaterSettings { [weak self] output in
            switch output {
            case .close:
                self?.updateWater()
            case .updateSettings:
                self?.updateWater()
            }
        }
    }

    private func exploreWeight() {
        router.presentWeightProgress(weightUnits: defaultWeightUnits) { [weak self] output in
            switch output {
            case .weightUpdated:
                self?.updateWeight()
            }
        }
        trackTapInfo(source: "learn_more", target: "weight")
    }

    @MainActor
    private func updateWeight(chartItems: [LineChartItem], currentWeight: WeightHistory?) {
        if let currentWeight {
            self.currentWeightSubject.send(currentWeight.trueWeight)
        }
        weightChartItems = chartItems
    }
}

private extension StorageService {
    var isBodyMassIndexHintPresented: Bool {
        get { get(key: isBodyMassIndexHintPresentedKey, defaultValue: true) }
        set { set(key: isBodyMassIndexHintPresentedKey, value: newValue) }
    }

    var isWeightHintPresented: Bool {
        get { get(key: isWeightHintPresentedKey, defaultValue: true) }
        set { set(key: isWeightHintPresentedKey, value: newValue) }
    }
}

private extension HealthProgressViewModel {
    func trackTapInfo(source: String, target: String) {
        trackerService.track(.tapInfo(context: "progress", source: source, target: target))
    }
}
