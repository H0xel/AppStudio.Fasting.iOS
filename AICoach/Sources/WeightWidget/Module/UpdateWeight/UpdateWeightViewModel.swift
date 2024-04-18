//  
//  UpdateWeightViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import AppStudioFoundation
import AppStudioStyles
import AppStudioModels
import Dependencies

class UpdateWeightViewModel: BaseViewModel<UpdateWeightOutput> {

    @Dependency(\.weightService) private var weightService
    @Dependency(\.userPropertyService) private var userPropertyService

    @Published var currentDate: Date
    @Published var weight: Double = 0
    @Published var units: WeightUnit = .lb
    @Published var currentHistory: WeightHistory?
    @Published private var currentWeek: Week = .current
    let calendarViewModel = CalendarProgressViewModel(isFutureAllowed: false, withFullProgress: true)
    var router: UpdateWeightRouter!

    init(input: UpdateWeightInput, output: @escaping UpdateWeightOutputBlock) {
        currentDate = input.date.startOfTheDay
        units = input.units
        super.init(output: output)
        initializeCalendar()
    }

    var shouldShowTodayButton: Bool {
        currentWeek != .current
    }

    func save() {
        Task {
            let history = currentHistory?.updated(scaleWeight: weight)
            let newHistory = history ?? WeightHistory(scaleWeightValue: weight,
                                                      trueWeightValue: 0,
                                                      weightUnits: units,
                                                      historyDate: currentDate)
            let savedHistory = try await weightService.save(history: newHistory)
            updateUserProperty()
            output(.weightUpdated(savedHistory))
            await router.dismiss()
        }
    }

    func onTodayTap() {
        currentDate = .now.startOfTheDay
        calendarViewModel.currentWeek = .current
    }

    private func initializeCalendar() {
        calendarViewModel.initialize { [weak self] output in
            switch output {
            case .dateChange(let date):
                self?.currentDate = date
            case .updateProgress, .swipeDirection:
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
                self.updateWeight(date: date)
            }
            .store(in: &cancellables)
    }

    private func updateWeight(date: Date) {
        Task {
            let history = try await weightService.history(exactDate: date)
            await MainActor.run {
                currentHistory = history
                units = history?.weightUnits ?? units
                weight = Double(history?.scaleWeight.value ?? 0)
            }
        }
    }

    private func updateUserProperty() {
        guard currentHistory == nil else {
            return
        }
        userPropertyService.incrementProperty(property: "weigh_in_count", value: 1)
    }
}
