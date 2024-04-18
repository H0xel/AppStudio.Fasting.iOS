//  
//  HealthOverviewViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Combine
import AppStudioStyles
import Dependencies
import AppStudioModels
import WaterCounter
import FastingWidget
import WeightWidget

class HealthOverviewViewModel: BaseViewModel<HealthOverviewOutput> {

    @Dependency(\.calendarProgressService) private var calendarProgressService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.firstLaunchService) private var firstLaunchService

    @Published var monetizationIsAvailable: Bool = false
    @Published var currentDay: Date = .now.startOfTheDay

    let calendarViewModel = CalendarProgressViewModel(isFutureAllowed: false, withFullProgress: false)
    let swipeDaysViewModel = SwipeDaysViewModel(isFutureAllowed: false)
    let waterCounterViewModel = WaterCounterWidgetViewModel { _ in }
    let fastingWidgetViewModel: FastingWidgetViewModel
    let weightWidgetViewModel = WeightWidgetViewModel()
    let router: HealthOverviewRouter

    init(router: HealthOverviewRouter,
         input: HealthOverviewInput,
         output: @escaping HealthOverviewOutputBlock) {
        self.router = router
        fastingWidgetViewModel = .init(input: input.fastingWidget.input,
                                       output: input.fastingWidget.output)
        super.init(output: output)
        initializeCalendar()
        weightWidgetViewModel.initialize(navigator: router.navigator, 
                                         currentDatePublisher: $currentDay, 
                                         units: input.weightUnits,
                                         output: { _ in })
        waterCounterViewModel.router = WaterCounterWidgetRouter(navigator: router.navigator)
        input.monetizationIsAvailable
            .assign(to: &$monetizationIsAvailable)
    }

    func scrollToToday() {
        trackerService.track(.tapBackToToday)
        updateDate(date: .now.startOfTheDay)
    }

    func presentProfile() {
        trackerService.track(.tapProfile)
        output(.profileTapped)
    }

    func presentPaywall() {
        output(.showPaywall)
    }

    func appeared() {
        if monetizationIsAvailable, !firstLaunchService.isFirstTimeLaunch {
            presentPaywall()
        }
    }

    private func initializeCalendar() {
        calendarViewModel.initialize { [weak self] output in
            switch output {
            case .updateProgress(let weeks):
                self?.updateWeeks(weeks: weeks)
            case .dateChange(let date):
                self?.trackerService.track(.tapDate(date: date.description))
                self?.swipeDaysViewModel.updateCurrentDate(to: date)
            }
        }

        swipeDaysViewModel.initialize { [weak self] output in
            switch output {
            case .dateUpdated(let date):
                self?.currentDay = date
                self?.calendarViewModel.updateCurrentDay(for: date)
            }
        }

        calendarViewModel.observeProgress(publisher: calendarProgressService.historyPublisher)

        $currentDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.updateDate(date: date)
            }
            .store(in: &cancellables)
    }

    private func updateDate(date: Date) {
        swipeDaysViewModel.updateCurrentDate(to: date)
        calendarViewModel.updateCurrentDay(for: date)
    }

    private func updateWeeks(weeks: [Week]) {
        swipeDaysViewModel.insertDays(of: weeks)
        fastingWidgetViewModel.loadData(weeks: weeks)
    }
}

// MARK: - Analytics
extension HealthOverviewViewModel {
    func trackNextDay(_ date: Date) {
        trackerService.track(.tapNextDay(targetDate: date.description))
    }

    func trackPrevDay(_ date: Date) {
        trackerService.track(.tapPreviousDay(targetDate: date.description))
    }
}
