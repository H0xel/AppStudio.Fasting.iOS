//
//  CurrentPeriodViewConfiguration.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 05.09.2024.
//

import SwiftUI

enum PeriodConfiguration {
    case periodInProgress(days: Int)
    case ovulation(daysUntil: Int)
    case period(daysUntil: Int)

    var numberOfDays: Int {
        switch self {
        case .periodInProgress(let days):
            return days
        case .ovulation(let daysUntil):
            return daysUntil
        case .period(let daysUntil):
            return daysUntil
        }
    }

    var buttonText: String {
        switch self {
        case .periodInProgress:
            return "CurrentPeriodViewConfiguration.editPeriodDates".localized()
        case .ovulation:
            return "CurrentPeriodViewConfiguration.logPeriod".localized()
        case .period:
            return "CurrentPeriodViewConfiguration.logPeriod".localized()
        }
    }

    var labelText: String {
        // TODO: - Возвращать правильное значение в зависимости от количества дней
        switch self {
        case .periodInProgress(let days):
            return "CurrentPeriodViewConfiguration.lowPregnancyChance".localized()
        case .ovulation(let daysUntil):
            if daysUntil == 0 {
                return "CurrentPeriodViewConfiguration.highPregnancyChance".localized()
            }
            return "CurrentPeriodViewConfiguration.lowPregnancyChance".localized()
        case .period(let daysUntil):
            return "CurrentPeriodViewConfiguration.lowPregnancyChance".localized()
        }
    }

    var subtitle: String {
        switch self {
        case .periodInProgress:
            return "CurrentPeriodViewConfiguration.periodInProgress.subtitle".localized()
        case .ovulation(let daysUntil):
            if daysUntil == 0 {
                return "CurrentPeriodViewConfiguration.ovulationDay.subtitle".localized()
            }
            if daysUntil == 1 {
                return "CurrentPeriodViewConfiguration.ovulation.subtitle.single".localized()
            }
            return "CurrentPeriodViewConfiguration.ovulation.subtitle.plural".localized()
        case .period(let daysUntil):
            if daysUntil == 1 {
                return "CurrentPeriodViewConfiguration.period.subtitle.single".localized()
            }
            return "CurrentPeriodViewConfiguration.period.subtitle.plural".localized()
        }
    }

    var gradientColors: [Gradient.Stop] {
        switch self {
        case .periodInProgress:
            return [
                .init(color: .studioPurple, location: 0.3),
                .init(color: .studioRed, location: 1)
            ]
        case .ovulation(let daysUntil):
            if daysUntil > 0 {
                return [
                    .init(color: .studioGreen, location: 0.7),
                    .init(color: .studioSky, location: 1)
                ]
            }
            return [
                .init(color: .studioSky, location: 0.25),
                .init(color: .studioBlue, location: 0.5),
                .init(color: .studioPurple, location: 1)

            ]
        case .period:
            return [
                .init(color: .studioPurple, location: 0.7),
                .init(color: .studioRed, location: 1)
            ]
        }
    }
}
