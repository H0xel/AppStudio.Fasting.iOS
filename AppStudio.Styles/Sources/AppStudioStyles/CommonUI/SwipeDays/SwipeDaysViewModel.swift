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
    @Published public var currentDay: Date
    @Published var displayDays: [Date] = []
    private let isFutureAllowed: Bool

    public init(isFutureAllowed: Bool) {
        currentDay = .now.startOfTheDay
        self.isFutureAllowed = isFutureAllowed
        super.init()
        updateDisplayDays()
        observeCurrentDateChange()
    }

    public func updateCurrentDate(to newDate: Date) {
        guard newDate != currentDay else {
            return
        }
        currentDay = newDate
    }

    private func updateDisplayDays() {
        let currentWeek = Week(ofDay: currentDay)
        let days = [currentWeek.previous, currentWeek, currentWeek.next].flatMap { $0.days }
        displayDays = isFutureAllowed ? days : days.filter { $0 <= .now.startOfTheDay }
    }

    private func observeCurrentDateChange() {
        $currentDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self else { return }
                self.output(.dateUpdated(date))
                self.updateDisplayDays()
            }
            .store(in: &cancellables)
    }
}
