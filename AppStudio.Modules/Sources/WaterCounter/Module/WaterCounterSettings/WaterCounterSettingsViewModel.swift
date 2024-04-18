//  
//  WaterCounterSettingsViewModel.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Combine
import Dependencies

class WaterCounterSettingsViewModel: BaseViewModel<WaterCounterSettingsOutput> {
    var router: WaterCounterSettingsRouter!
    @Dependency(\.waterService) private var waterService
    @Dependency(\.waterIntakeService) private var waterIntakeService
    @Dependency(\.trackerService) private var trackerService

    @Published var settings: WaterSettings = .default {
        didSet { output(.updateSettings) }
    }
    @Published var waterGoal: DailyWaterGoal = .default {
        didSet { output(.updateSettings) }
    }

    override init(output: @escaping WaterCounterSettingsOutputBlock) {
        super.init(output: output)
        Task {
            try await loadSettings()
        }
    }

    var goalValueTitle: String {
        "\(settings.units.formatGlobal(value: waterGoal.quantity)) \(settings.units.unitsGlobalFullTitle.lowercased())"
    }

    var prefferedVolumeTitle: String {
        "\(settings.units.format(value: settings.prefferedValue)) \(settings.units.unitsTitle)"
    }

    var unitsTitle: String {
        "\(settings.units.unitsGlobalFullTitle)"
    }

    @MainActor
    private func loadSettings() async throws {
        self.settings = try await waterService.settings()
        self.waterGoal = try await waterService.dailyGoal(for: .now)
    }

    @MainActor
    private func updateDailyGoal(to value: Double) async throws {
        let quantity = settings.units.globalToValue(value: value)
        if waterGoal.quantity != quantity, quantity > 0 {
            trackerService.track(.waterGoalUpdated(oldGoal: "\(self.waterGoal.quantity)", 
                                                   newGoal: "\(quantity)"))
            self.waterGoal = try await waterService.save(dailyGoal: DailyWaterGoal(quantity: quantity, date: .now))
        }
    }

    @MainActor
    private func updatePrefferedVolume(to value: Double) async throws {
        let newValue = settings.units.localToValue(value: value)
        if settings.prefferedValue != newValue, newValue > 0 {
            trackerService.track(.preferredVolumeUpdated(volume: "\(newValue)"))
            self.settings = try await waterService.save(settings: .init(date: .now, prefferedValue: newValue, units: settings.units))
        }
    }

    func showDaylyGoalEditor() {
        trackerService.track(.tapChangeWaterGoal)
        let calculatedDailyGoal: Double = waterIntakeService.waterIntake ?? 2500
        router.presentDaylyGoalEditor(
            value: settings.units.valueToGlobal(value: waterGoal.quantity),
            calcValue: settings.units.formatGlobal(value: calculatedDailyGoal),
            units: settings.units
        ) { output in
            switch output {
            case .value(let value):
                Task { [weak self] in
                    try await self?.updateDailyGoal(to: value)
                }
            case .close:
                break
            case .onTapPrefferedChips:
                break
            }
        }
    }

    func showPrefferedValueEditor() {
        let trackerService = trackerService        
        trackerService.track(.tapChangePreferredVolume)
        router.presentPrefferedVolumeEditor(
            value: settings.units.valueToLocal(value: settings.prefferedValue),
            units: settings.units,
            predefinedValues: settings.units.predefinedValues
        ) { output in
            switch output {
            case .value(let value):
                Task { [weak self] in
                    try await self?.updatePrefferedVolume(to: value)
                }
            case .close:
                break
            case .onTapPrefferedChips(let value):
                trackerService.track(.tapVolumeChip(volume: "\(value)",
                                                    context: "preferred_volume_setting"))
            }
        }
    }

    @MainActor
    private func update(units: WaterUnits) async throws {
        settings = try await waterService.save(settings: .init(date: .now, prefferedValue: settings.prefferedValue, units: units))
        trackerService.track(.waterUnitsUpdated(newUnits: units.unitsGlobalFullTitle.lowercased()))
    }

    func showUnitsEditor() {
        trackerService.track(.tapChangeWaterUnits)
        let prevSettings = settings
        router.presentUnitsSelector(value: settings.units) { output in
            switch output {
            case .value(let value):
                if value != prevSettings.units.rawValue, let newUnits = WaterUnits(rawValue: value) {
                    Task { [weak self] in
                        try await self?.update(units: newUnits)
                    }
                }
            case .close:
                break
            }
        }
    }

    func close() {
        output(.close)
        router.dismiss()
    }
}
