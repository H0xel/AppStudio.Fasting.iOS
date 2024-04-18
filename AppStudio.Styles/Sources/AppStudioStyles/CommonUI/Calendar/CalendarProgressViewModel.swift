//
//  CalendarProgressViewModel.swift
//
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import Foundation
import AppStudioUI
import Dependencies
import Combine
import AppStudioModels

public enum CalendarProgressOutput {
    case updateProgress([Week])
    case dateChange(Date)
    case swipeDirection(SwipeDirection)
}

struct CalendarProgress {
    let day: Date
    let progress: DayProgress
}

public class CalendarProgressViewModel: BaseViewModel<CalendarProgressOutput> {

    @Published public var currentDay: Date = .now.startOfTheDay
    @Published public var currentWeek: Week = .current
    @Published var availableWeeks: [Week] = []
    @Published private var progress: [Date: DayProgress] = [:]
    let isFutureAllowed: Bool
    let withFullProgress: Bool

    public init(isFutureAllowed: Bool, withFullProgress: Bool) {
        self.isFutureAllowed = isFutureAllowed
        self.withFullProgress = withFullProgress
        super.init()
        availableWeeks = [.current]
        observeCurrentWeekChange()
    }

    func weekProgress(for week: Week) -> [CalendarProgress] {
        week.days.map { .init(day: $0, progress: progress(for: $0)) }
    }

    public func observeProgress(publisher: AnyPublisher<[Date: DayProgress], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self else { return }
                self.output(.updateProgress([self.currentWeek]))
            })
            .assign(to: &$progress)
    }

    public func updateProgress(date: Date, progress: DayProgress) {
        self.progress[date] = progress
    }

    public func updateCurrentDay(for newDate: Date) {
        guard newDate != currentDay else {
            return
        }
        DispatchQueue.main.async {
            self.currentDay = newDate
            let currentWeek = Week(ofDay: newDate)
            self.currentWeek = currentWeek
            self.updateAvailableWeeks(currentWeek: currentWeek)
        }
    }

    func selectDate(_ date: Date) {
        guard date != currentDay else { return }
        if !isFutureAllowed, date > .now {
            return
        }
        currentDay = date
        output(.dateChange(date))
    }

    private func progress(for day: Date) -> DayProgress {
        progress[day] ?? .init(goal: withFullProgress ? 0 : 1, result: 0)
    }

    private func observeCurrentWeekChange() {
        $currentWeek
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] week in
                self?.updateAvailableWeeks(currentWeek: week)
            }
            .store(in: &cancellables)

        $currentWeek
            .dropFirst()
            .sink { [weak self] week in
                guard let self else { return }
                let direction: SwipeDirection = week > self.currentWeek ? .forward : .backward
                output(.swipeDirection(direction))
            }
            .store(in: &cancellables)
    }

    private func updateAvailableWeeks(currentWeek: Week) {
        var weeks: [Week] = [currentWeek.previous, currentWeek, currentWeek.next]
        if !isFutureAllowed {
            weeks = weeks.filter { $0 <= .current }
        }
        availableWeeks = weeks
        output(.updateProgress(weeks))
    }
}
