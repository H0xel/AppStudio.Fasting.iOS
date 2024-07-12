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
    @Dependency(\.weightGoalService) private var weightGoalService

    var router: HealthProgressRouter!
    @Published var isBodyMassHintPresented = true
    @Published var isWeightHintPresented = true
    @Published var bodyMassIndex: Double = 0
    @Published var fastingChartItems: [HealthProgressBarChartItem] = []
    @Published var fastingHistoryData: FastingHistoryData = .init(records: [])
    @Published var waterChartItems: [HealthProgressBarChartItem] = []
    @Published var weightChartItems: [LineChartItem] = []
    @Published var isMonetization = false
    @Published private var weightGoalStartWeight: WeightMeasure?

    private var fastingChartHistoryItemsSubject = CurrentValueSubject<[FastingHistoryChartItem], Never>([])
    private var waterChartHistoryItemsSubject = CurrentValueSubject<[FastingHistoryChartItem], Never>([])
    @Published private var waterUnits: WaterUnits = .ounces
    private let currentWeightSubject = CurrentValueSubject<WeightMeasure, Never>(.init(value: 0))
    private var inputCancellable: AnyCancellable?
    private var defaultWeightUnits: WeightUnit = .lb
    private let inputHistoryPublisher: AnyPublisher<FastingHealthProgressInput, Never>

    init(isMonetizationExpAvailablePublisher: AnyPublisher<Bool, Never>,
         inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
         output: @escaping HealthProgressOutputBlock) {
        inputHistoryPublisher = inputPublisher
        super.init(output: output)
        isMonetizationExpAvailablePublisher.assign(to: &$isMonetization)
        observeInput(inputPublisher: inputPublisher)
        isBodyMassHintPresented = storageService.isBodyMassIndexHintPresented
        isWeightHintPresented = storageService.isWeightHintPresented
    }

    var weightGoalRoute: Route {
        WeightGoalWidgetRoute(
            navigator: router.navigator,
            input: .init(currentWeightPublisher: currentWeightSubject.eraseToAnyPublisher(),
                         startWeightPublisher: $weightGoalStartWeight.compactMap { $0 }.eraseToAnyPublisher()),
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
            presentFastingHistory(
                input: .init(context: .fasting,
                             historyData: fastingHistoryData,
                             chartItems: fastingChartHistoryItemsSubject.eraseToAnyPublisher(),
                             inputHistoryPublisher: inputHistoryPublisher)
            )

        case .emptyStateButtonTap:
            break
        case .presentPaywall:
            self.output(.presentMultipleProductPaywall)
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
        case .presentPaywall:
            self.output(.presentMultipleProductPaywall)
        }
    }

    func handleWaterWidgetOutput(output: HealthChartOutput) {
        switch output {
        case .infoTap:
            presentWaterSettings()
        case .learnMoreTap:
            presentFastingHistory(input: .init(context: .water(waterUnits), 
                                               historyData: .mock,
                                               chartItems: waterChartHistoryItemsSubject.eraseToAnyPublisher(),
                                               inputHistoryPublisher: Empty().eraseToAnyPublisher()))
        case .emptyStateButtonTap:
            break
        case .presentPaywall:
            self.output(.presentMultipleProductPaywall)
        }
    }

    func presentBodyMassIndexInfo(source: String) {
        trackTapInfo(source: source, target: "bmi")
        router.presentBodyMassIndexHint(bodyMassIndex: bodyMassIndex.bodyMassIndex) { [weak self] question in
            self?.output(.novaQuestion(question))
        }
    }


    func updateWeight() {
        Task { [weak self] in
            guard let self else { return }
            async let items = weightChartService.lastDaysItems(daysCount: 7)
            async let weight = weightService.history(byDate: .now)
            try await updateWeight(chartItems: items, currentWeight: weight)

            let weightGoal = try await weightGoalService.currentGoal()
            let weightGoalStartWeight = try await weightService.history(byDate: weightGoal.dateCreated)
            await MainActor.run {
                self.weightGoalStartWeight = weightGoalStartWeight?.trueWeight
            }
        }
    }

    func updateWater() {
        Task {
            let calendar = Calendar.current
            var components = DateComponents()

            components.year = 2023
            components.month = 12
            components.day = 1

            let startingWaterTrackingDay = calendar.date(from: components) ?? .now
            let daysAfterStartingWaterTrackingDay = calendar.dateComponents([.day],
                                                                           from: startingWaterTrackingDay,
                                                                           to: .now).day ?? 0

            let fastingHistoryDates = (0...daysAfterStartingWaterTrackingDay).map { Date.now.startOfTheDay.adding(.day, value: -$0) }.reversed()
            let dates = (0 ..< 7).map { Date.now.startOfTheDay.adding(.day, value: -$0) }.reversed()
            let items = try await waterChartService.waterChartItems(for: Array(dates))
            let historyItems = try await waterChartService.waterHistoryChartItems(for: Array(fastingHistoryDates))
            let waterUnits = try await waterChartService.waterUnits()

            await MainActor.run {
                waterChartItems = items
                self.waterChartHistoryItemsSubject.send(historyItems)
                self.waterUnits = waterUnits
            }
        }
    }

    private func observeInput(inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>) {
        inputCancellable = inputPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                self?.bodyMassIndex = input.bodyMassIndex
                self?.fastingChartItems = input.fastingChartItems
                self?.fastingChartHistoryItemsSubject.send(input.fastingHistoryChartItems)
                self?.defaultWeightUnits = input.weightUnits
                self?.fastingHistoryData = input.fastingHistoryData
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
        if isMonetization {
            output(.presentMultipleProductPaywall)
            return
        }
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

    private func presentFastingHistory(input: FastingHistoryInput) {

        if isMonetization {
            output(.presentMultipleProductPaywall)
            return
        }

        router.pushFastingHistory(input: input) { [weak self] result in
            switch result {
            case .close:
                break
            case .delete(let historyId):
                self?.output(.delete(historyId: historyId))
            case .edit(let historyId):
                self?.output(.edit(historyId: historyId))
            case .addHistory:
                self?.output(.addHistory)
            case .updateWater:
                self?.updateWater()
            }
        }
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
