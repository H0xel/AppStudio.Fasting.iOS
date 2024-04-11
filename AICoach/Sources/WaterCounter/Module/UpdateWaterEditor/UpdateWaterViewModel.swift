//  
//  UpdateWaterViewModel.swift
//  
//
//  Created by Denis Khlopin on 09.04.2024.
//

import AppStudioNavigation
import AppStudioUI
import Dependencies
import Foundation
import AppStudioStyles
import AppStudioModels

class UpdateWaterViewModel: BaseViewModel<UpdateWaterOutput> {
    var router: UpdateWaterRouter!
    let calendarViewModel = CalendarProgressViewModel(isFutureAllowed: false, withFullProgress: true)
    let units: WaterUnits
    @Published var currentWater: Double = 0
    @Published var currentDate: Date
    @Published var allWater: [Date: DrinkingWater]
    @Published private var currentWeek: Week = .current

    @Dependency(\.waterService) private var waterService


    init(input: UpdateWaterInput, output: @escaping UpdateWaterOutputBlock) {
        self.units = input.units
        self.currentDate = input.date
        self.allWater = input.allWater

        super.init(output: output)
        initializeCalendar()
    }

    var shouldShowTodayButton: Bool {
        currentWeek != .current
    }

    func onTodayTap() {
        currentDate = .now.beginningOfDay
        calendarViewModel.currentWeek = .current
    }

    @MainActor
    private func loadWater() async throws {
        allWater = try await waterService.water()
    }


    func save() {
        Task {
            let quantity = units.globalToValue(value: currentWater)
            let updatedValue = try await waterService.updateWater(for: currentDate, quantity: quantity)
            output(.updated(updatedValue))
            await router.dismiss()
        }
    }

    private func initializeCalendar() {
        calendarViewModel.initialize { [weak self] output in
            switch output {
            case .dateChange(let date):
                self?.currentDate = date
            case .updateProgress:
                break
            }
        }
        calendarViewModel.$currentDay
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentDate)

        calendarViewModel.$currentWeek
            .assign(to: &$currentWeek)

        $currentDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self else { return }
                self.calendarViewModel.updateCurrentDay(for: date)
                self.updateCurrentWater(date: date)
            }
            .store(in: &cancellables)
    }

    func updateCurrentWater(date: Date) {
        Task {
            try await loadWater()
            await MainActor.run {
                let quantity = allWater[date]?.quantity ?? 0.0

                currentWater = units.valueToGlobal(value: quantity)
            }
        }
    }
}
