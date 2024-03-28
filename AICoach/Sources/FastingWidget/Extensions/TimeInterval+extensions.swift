//
//  TimeInterval+extensions.swift
//  
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
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

    var toMinutesInt: Int {
        let left = Int(self)
        let minutes = left / 60
        let minutesLeft = minutes % 60
        return minutesLeft
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
