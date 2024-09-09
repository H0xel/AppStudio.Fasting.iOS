//
//  PeriodTrackerViewModel.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import Foundation
import AppStudioUI
import AppStudioStyles

class PeriodTrackerViewModel: BaseViewModel<PeriodTrackerOutput> {

    @Published var currentDate: Date = .now.startOfTheDay
    @Published var configuration = PeriodConfiguration.period(daysUntil: 3)

    let calendarViewModel = CalendarProgressViewModel(isFutureAllowed: true,
                                                      withFullProgress: false)

    private let router: PeriodTrackerRouter

    init(router: PeriodTrackerRouter,
         input: PeriodTrackerInput,
         output: @escaping ViewOutput<PeriodTrackerOutput>) {
        self.router = router
        super.init(output: output)
        initializeCalendar()
    }

    func scrollToToday() {
        calendarViewModel.updateCurrentDay(for: .now)
    }

    func logPeriod() {}

    private func initializeCalendar() {
        calendarViewModel.initialize { [weak self] output in
            self?.handle(calendarOutput: output)
        }

        $currentDate
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, date in
                this.calendarViewModel.updateCurrentDay(for: date)
            }
            .store(in: &cancellables)
    }

    private func handle(calendarOutput output: CalendarProgressOutput) {
        switch output {
        case .updateProgress(let weeks):
            break
        case .dateChange(let date):
            currentDate = date
        case .swipeDirection(let swipeDirection):
            break
        }
    }
}

// MARK: - Tracking
extension PeriodTrackerViewModel {
    func trackPrevDay(_ date: Date) {
    }

    func trackNextDay(_ date: Date) {
    }
}
