//  
//  WaterCounterWidgetViewModel.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Dependencies

public class WaterCounterWidgetViewModel: BaseViewModel<WaterCounterWidgetOutput> {
    public var router: WaterCounterWidgetRouter!

    @Dependency(\.waterService) private var waterService
    @Dependency(\.trackerService) private var trackerService

    @Published var water: [Date: Double] = [:]
    @Published var goals: [Date: Double] = [:]
    @Published var observers: [Date: DrinkingWaterObserver] = [:]

    @Published var settings: WaterSettings?

    public override init(output: @escaping ViewOutput<WaterCounterWidgetOutput>) {
        super.init(output: output)
        Task {
            try await loadSettings()
        }
    }

    func percent(for date: Date) -> Double {
        guard let water = water[date], let goal = goals[date], goal != 0 else {
            return 0.0
        }

        let percent = abs(water / goal)
        return percent > 1 ? 1 : percent
    }

    func currentWaterTitle(for date: Date) -> String {
        guard let settings, let water = water[date] else {
            return ""
        }
        return "\(settings.units.formatGlobal(value: water))"
    }

    func totalWaterTitle(for date: Date) -> String {
        guard let settings, let goal = goals[date] else {
            return ""
        }
        return "/\(settings.units.formatGlobal(value: goal)) \(settings.units.unitsGlobalTitle)"
    }

    var prefferdWaterValueTitle: String {
        guard let settings else {
            return ""
        }
        return "\(settings.units.format(value: settings.prefferedValue)) \(settings.units.unitsTitle)"
    }

    func update(for date: Date) {
        Task { [weak self] in
            await self?.observeWater(for: date)
            try await self?.loadGoal(date: date)
            try await self?.loadSettings()
        }
    }

    @MainActor
    private func loadGoal(date: Date) async throws {
        goals[date] = try await waterService.dailyGoal(for: date).quantity
    }

    @MainActor
    private func loadSettings() async throws {
        settings = try await waterService.settings()
    }

    @MainActor
    private func observeWater(for date: Date) {

        guard observers[date] == nil else {
            return
        }

        let waterObserver = waterService.waterObserver(for: date)
        waterObserver.results
            .map {
                $0.reduce(into: 0.0) { partialResult, water in
                    partialResult += water.quantity
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { this, water in
                this.water[date] = abs(water)
            })
            .store(in: &cancellables)

        self.observers[date] = waterObserver
    }

    func showAddWater(for date: Date) {
        let trackerService = trackerService
        guard let settings else {
            return
        }
        router.presentAddWaterEditor(
            units: settings.units, 
            predefinedValues: settings.units.predefinedValues
        ) { [weak self] output in
            switch output {
            case .value(let value):
                trackerService.track(.tapAddCustomVolume(date: date.description, volume: "\(value)"))
                let newValue = settings.units.localToValue(value: value)
                self?.addWater(for: date, value: newValue)
            case .close:
                break
            case .onTapPrefferedChips(let value):
                trackerService.track(.tapVolumeChip(volume: "\(value)", context: "custom_volume"))
            }
        }
    }

    func showSettings(for date: Date) {
        trackerService.track(.tapWaterSettings(context: "daily"))
        router.presentSettings { output in
            Task {
                try await self.loadSettings()
                try await self.loadGoal(date: date)
            }
        }
    }

    func addWater(for date: Date, value: Double? = nil) {
        guard let quantity = value ?? settings?.prefferedValue else {
            return
        }
        if value == nil {
            trackerService.track(
                .tapAddPreferredVolume(date: date.description, volume: "\(quantity)")
            )
        }
        Task { [weak self] in
            let addedValue = try await self?.waterService.add(water: .init(date: date, quantity: quantity))

            if let addedValue, addedValue > 0 {
                self?.trackerService.track(
                    .drinkAdded(volume: "\(addedValue)",
                                context: value == nil ? "preferred_volume" : "custom_volume")
                )
            }
        }
    }

    func removeWater(for date: Date) {
        guard let quantity = settings?.prefferedValue else {
            return
        }
        trackerService.track(
            .tapRemovePreferredVolume(date: date.description, volume: "\(quantity)")
        )
        Task { [weak self] in
            let addedValue = try await self?.waterService.add(water: .init(date: date, quantity: -quantity))

            if let addedValue, addedValue != 0 {
                self?.trackerService.track(
                    .drinkAdded(volume: "\(addedValue)", context: "preferred_volume")
                )
            }
        }
    }
}
