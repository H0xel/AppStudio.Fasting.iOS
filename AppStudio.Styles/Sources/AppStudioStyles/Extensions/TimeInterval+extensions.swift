//
//  TimeInterval+extensions.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import Foundation

extension TimeInterval {
    var toTime: String {
        let left = Int(self)
        let seconds = left % 60
        let minutes = left / 60
        let minutesLeft = minutes % 60
        let hours = minutes / 60

        let hoursString = hours.withLeadingZeroIfOneNumber
        let minutesString = minutesLeft.withLeadingZeroIfOneNumber
        let secondsString = seconds.withLeadingZeroIfOneNumber
        return "\(hoursString):\(minutesString):\(secondsString)"
    }

    var toHour: Int {
        let left = Int(self)
        let minutes = left / 60
        let hours = minutes / 60
        return hours
    }

    var toHours: String {
        let left = Int(self)
        let minutes = left / 60
        let hours = minutes / 60
        return hours.withLeadingZeroIfOneNumber
    }

    var toHoursLeft: String {
        let left = Int(self)
        let minutes = left / 60
        let hours = minutes / 60
        let hoursLeft = hours % 24
        return hoursLeft.withLeadingZeroIfOneNumber
    }

    var toDays: String {
        let left = Int(self)
        let minutes = left / 60
        let hours = minutes / 60
        let days = hours / 24
        return days.withLeadingZeroIfOneNumber
    }

    var toMinutes: String {
        let left = Int(self)
        let minutes = left / 60
        let minutesLeft = minutes % 60
        return minutesLeft.withLeadingZeroIfOneNumber
    }

    var toSeconds: String {
        let left = Int(self)
        let seconds = left % 60
        return seconds.withLeadingZeroIfOneNumber
    }
}

extension Int {
    var withLeadingZeroIfOneNumber: String {
        self > 9 ? "\(self)" : "0\(self)"
    }
}
