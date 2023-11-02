//
//  TimeInterval+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
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
}
