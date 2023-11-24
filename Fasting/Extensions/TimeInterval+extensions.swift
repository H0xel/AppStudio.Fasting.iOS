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

    var toHours: String {
        let left = Int(self)
        let minutes = left / 60
        let hours = minutes / 60
        return hours.withLeadingZeroIfOneNumber
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

    var fastingStage: FastingStage {
        switch self {
        case 0 ... .hour * 2:
            return .sugarRises
        case .hour * 2 ... .hour * 8:
            return .sugarDrop
        case .hour * 8 ... .hour * 10:
            return .sugarNormal
        case .hour * 10 ... .hour * 14:
            return .burning
        case .hour * 14 ... .hour * 16:
            return .ketosis
        default:
            return .autophagy
        }
    }
}
