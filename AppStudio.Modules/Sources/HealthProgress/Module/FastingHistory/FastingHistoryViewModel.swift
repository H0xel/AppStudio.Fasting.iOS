//  
//  FastingHistoryViewModel.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Combine
import Foundation
import AppStudioModels
import WaterCounter
import Dependencies

struct WaterWithGoal: Hashable {
    let date: Date
    let quantity: String
    let unit: String
    let goal: String
    let isGoalReached: Bool
}

struct WaterHistoryData {
    var water: [WaterWithGoal]
}

@available(iOS 17.0, *)
class FastingHistoryViewModel: BaseViewModel<FastingHistoryOutput> {
    var router: FastingHistoryRouter!
    let context: FastingHistoryInput.Context
    @Published var chartItems: [FastingHistoryChartItem] = []
    @Published var initialPosition: Date = .now
    @Published var fastingHistoryData: FastingHistoryData
    @Published var waterHistoryData: WaterHistoryData = .init(water: [])
    @Published var selectedPeriod: GraphPeriod = .month
    var scrollDate: AnyPublisher<Date, Never> {
        scrollDateTrigger.eraseToAnyPublisher()
    }
    private var scrollDateTrigger: CurrentValueSubject<Date, Never> = .init(.now)
    @Published var selectedItem: FastingHistoryChartItem?

    @Dependency(\.waterService) var waterService
    private var waterObserver: DrinkingWaterObserver?
    private var waterUnits: WaterUnits = .liters
    private var allWater: [Date: DrinkingWater] = [:]

    init(input: FastingHistoryInput, output: @escaping FastingHistoryOutputBlock) {
        fastingHistoryData = input.historyData
        context = input.context
        super.init(output: output)
        observe(input: input)
        initializeGraphPosition()
        input.chartItems
            .assign(to: &$chartItems)
    }

    func observe(input: FastingHistoryInput) {
        switch input.context {
        case .fasting:
            input.inputHistoryPublisher
                .receive(on: DispatchQueue.main)
                .sink(with: self) { this, healthInput in
                this.fastingHistoryData = healthInput.fastingHistoryData
                this.chartItems = healthInput.fastingHistoryChartItems
            }
            .store(in: &cancellables)

        case .water:
            waterObserver = waterService.waterObserverAll()

            waterObserver?
                .results
                .receive(on: DispatchQueue.main)
                .sink(with: self, receiveValue: { this, _ in
                    Task {
                        try await this.updateWater()
                    }
                })
                .store(in: &cancellables)
        }

    }

    @MainActor
    func updateWater() async throws {
        let allWater = try await waterService.water()
        let allWaterArray = allWater.values.sorted(by: { $0.date > $1.date })
        var waterHistoryData = WaterHistoryData(water: [])
        let units = try await waterService.settings().units
        for water in allWaterArray {
            let goal = try await waterService.dailyGoal(for: water.date)
            waterHistoryData.water.append(WaterWithGoal(date: water.date, 
                                                        quantity: units.formatGlobal(value: water.quantity),
                                                        unit: units.unitsGlobalTitle,
                                                        goal: units.formatGlobal(value: goal.quantity),
                                                        isGoalReached: water.quantity >= goal.quantity))
        }
        self.waterHistoryData = waterHistoryData
        self.waterUnits = units
        self.allWater = allWater
        self.output(.updateWater)
    }

    func updateScrollDate(_ date: Date) {
        scrollDateTrigger.send(date)
    }

    func infoTapped() {
        router.presentFastingHint { _ in }
    }

    func periodSelected(_ period: GraphPeriod) {
        selectedPeriod = period
        resetSelectedItem()
        initializeGraphPosition()
    }

    func backTapped() {
        output(.close)
    }

    func resetSelectedItem() {
        selectedItem = nil
    }

    func delete(historyId: String) {
        output(.delete(historyId: historyId))
    }

    func edit(historyId: String) {
        output(.edit(historyId: historyId))
    }

    func addHistory() {
        output(.addHistory)
    }

    func deleteWater(at date: Date) {
        Task { [weak self] in
            try await self?.waterService.deleteWater(at: date)
            try await self?.updateWater()
        }
    }

    func editWater(at date: Date) {
        presentUpdateWaterEditor(
            input: UpdateWaterInput(units: waterUnits,
                                    date: date,
                                    allWater: allWater)
        )
    }

    func addWater() {
        presentUpdateWaterEditor(
            input: UpdateWaterInput(units: waterUnits,
                                    date: .now,
                                    allWater: allWater)
        )

    }

    func presentUpdateWaterEditor(input: UpdateWaterInput) {
        router.presentUpdateWaterEditor(input: input) { output in
            switch output {
            case .updated:
                Task {
                    try await self.updateWater()
                }
            }
        }
    }

    private func initializeGraphPosition() {
        let initialPosition =  Date.now.addingTimeInterval(.day * -Double(selectedPeriod.fastingHistoryVisibleDomain - 1))
        self.initialPosition = initialPosition
        updateScrollDate(initialPosition)
    }
}
