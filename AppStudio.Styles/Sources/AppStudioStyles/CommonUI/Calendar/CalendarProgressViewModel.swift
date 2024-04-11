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
}

struct CalendarProgress {
    let day: Date
    let progress: DayProgress
}

public class CalendarProgressViewModel: BaseViewModel<CalendarProgressOutput> {
    @Published public var currentDay: Date = .now.startOfTheDay
    @Published public var currentWeek: Week = .current
    @Published private var progress: [Date: DayProgress] = [:]
    @Published private var weeks: Set<Week> = []
    let isFutureAllowed: Bool
    let withFullProgress: Bool

    public init(isFutureAllowed: Bool, withFullProgress: Bool) {
        self.isFutureAllowed = isFutureAllowed
        self.withFullProgress = withFullProgress
        super.init()
        let weeks: [Week] = isFutureAllowed ?
        [.current.previous, .current, .current.next] :
        [.current.previous, .current]
        insertWeeks(weeks)
        observeCurrentWeekChange()
    }

    var availableWeeks: [Week] {
        weeks.sorted(by: <)
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

    public func updateCurrentDay(for newDate: Date) {
        guard newDate != currentDay else {
            return
        }
        DispatchQueue.main.async {
            self.currentDay = newDate
            if !self.currentWeek.contains(newDate) {
                self.currentWeek = .init(ofDay: newDate)
            }
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] week in
                guard let self else { return }
                let weeks: [Week] = [week.previous, week, week.next]
                self.output(.updateProgress(weeks))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.insertWeeks(weeks)
                }
            }
            .store(in: &cancellables)
    }

    private func insertWeeks(_ weeks: [Week]) {
        let filteredWeeks = isFutureAllowed ? weeks : weeks.filter { $0 <= .current }
        var newWeeks = self.weeks
        for week in filteredWeeks {
            newWeeks.insert(week)
        }
        self.weeks = newWeeks
    }
}
