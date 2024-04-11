//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import Foundation
import AppStudioUI
import AppStudioModels

public enum SwipeDaysOutput {
    case dateUpdated(Date)
}

public class SwipeDaysViewModel: BaseViewModel<SwipeDaysOutput> {
    @Published var currentDay: Date
    @Published private var days: Set<Date> = []
    private let isFutureAllowed: Bool

    public init(isFutureAllowed: Bool) {
        currentDay = .now.startOfTheDay
        self.isFutureAllowed = isFutureAllowed
        super.init()
        insertDays(of: [.init(ofDay: currentDay)])
        observeCurrentDateChange()
    }

    var displayDays: [Date] {
        days.sorted(by: <)
    }

    public func updateCurrentDate(to newDate: Date) {
        guard newDate != currentDay else {
            return
        }
        DispatchQueue.main.async {
            self.currentDay = newDate
        }
    }

    public func insertDays(of weeks: [Week]) {
        var newDays = days
        let days = weeks.flatMap { $0.days }
        let filteredDays = isFutureAllowed ? days : days.filter { $0 <= .now.startOfTheDay }
        filteredDays.forEach { day in
            newDays.insert(day)
        }
        self.days = newDays
    }

    private func observeCurrentDateChange() {
        $currentDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.output(.dateUpdated(date))
            }
            .store(in: &cancellables)
    }
}
