//
//  NotificationPrior.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import Foundation

enum NotificationPrior: String, CaseIterable, Hashable, CustomStringConvertible, Codable {
    case thirtyMin
    case oneHour
    case twoHour
    case threeHour

    var description: String {
        NSLocalizedString("NotificationPrior.\(rawValue)", comment: "")
    }

    var pushDescription: String {
        NSLocalizedString("NotificationPrior.push.\(rawValue)", comment: "")
    }

    var pushTitle: String {
        NSLocalizedString("NotificationPrior.pushTitle.\(rawValue)", comment: "")
    }

    var minutes: Int {
        switch self {
        case .thirtyMin: return 30
        case .oneHour: return 60
        case .twoHour: return 120
        case .threeHour: return 180
        }
    }
}
