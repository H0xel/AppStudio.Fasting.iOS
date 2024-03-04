//
//  Date+LocaleTime.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 08.11.2023.
//

import Foundation

extension Date {
    private var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }

    private var shortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = Locale.current.shortDateFormat
        return dateFormatter
    }

    private var paywallShortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = Locale.current.paywallShortDateFormat
        return dateFormatter
    }

    private var dateTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = Locale.current.shortDateTimeFormat
        return dateFormatter
    }

    var localeTimeString: String {
        timeFormatter.string(from: self)
    }

    var localeShortDateString: String {
        shortDateFormatter.string(from: self)
    }

    var localeDateTimeString: String {
        dateTimeFormatter.string(from: self)
    }

    var paywallLocaleDateTimeString: String {
        paywallShortDateFormatter.string(from: self)
    }

    var withoutSeconds: Date {
        guard let result = DateComponents(
            calendar: .current,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: 0
        ).date else {
            fatalError("wrong input date!")
        }
        return result
    }
}
