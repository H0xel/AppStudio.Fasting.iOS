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
import AppStudioServices
import Dependencies
import AppStudioModels
import WaterCounter
import FastingWidget
import WeightWidget
import RxSwift

class HealthOverviewViewModel: BaseViewModel<HealthOverviewOutput> {

    @Dependency(\.calendarProgressService) private var calendarProgressService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.firstLaunchService) private var firstLaunchService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    @Published var monetizationIsAvailable: Bool = false
    @Published var currentDay: Date = .now.startOfTheDay
    @Published var discountPaywallInfo: DiscountPaywallInfo?
    @Published var timerInterval: TimeInterval = .second
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
        subscribeForAvailableDiscountPaywall()
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
            output(.showPopUpPaywall)
        }
    }

    private func initializeCalendar() {
        calendarViewModel.initialize { [weak self] output in
            switch output {
            case .updateProgress(let weeks):
                self?.updateWeeks(weeks: weeks)
            case .dateChange(let date):
                self?.currentDay = date
                self?.trackerService.track(.tapDate(date: date.description))
            case .swipeDirection(let direction):
                self?.trackerService.track(.swipeWeek(direction: direction.rawValue))
            }
        }

        swipeDaysViewModel.initialize { [weak self] output in
            switch output {
            case .dateUpdated(let date):
                self?.currentDay = date
            }
        }

        calendarViewModel.observeProgress(publisher: calendarProgressService.historyPublisher)

        $currentDay
            .removeDuplicates()
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
        fastingWidgetViewModel.loadData(weeks: weeks)
    }
}

// MARK: DiscountExp

extension HealthOverviewViewModel {

    func handle(discountBannerAction action: DiscountBannerView.Action) {
        switch action {
        case .close:
            closeBannerTapped()
        case .openPaywall:
            bannerTapped()
        }
    }

    private func bannerTapped() {
        output(.showDiscountPaywall)
    }

    func updateTimer(discountPaywallInfo: DiscountPaywallInfo) {
        guard let interval = discountPaywallTimerService.getCurrentTimer(
            durationInSeconds: discountPaywallInfo.timerDurationInSeconds ?? 0
        ) else {
            return
        }

        timerInterval = interval
    }

    private func closeBannerTapped() {
        discountPaywallTimerService.stopTimer()
    }

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .receive(on: DispatchQueue.main)
            .assign(to: &$discountPaywallInfo)

        $discountPaywallInfo
            .sink(with: self) { this, info in
                if let info {
                    this.updateTimer(discountPaywallInfo: info)
                    this.startTimer()
                }
            }
            .store(in: &cancellables)
    }

    private func startTimer() {
        Publishers.Merge(timer, Just(.now))
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.timerInterval -= .second

                if this.timerInterval.seconds <= 0 {
                    this.discountPaywallTimerService.setAvailableDiscount(data: nil)
                    this.timer.upstream.connect().cancel()
                }
            }
            .store(in: &cancellables)
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
