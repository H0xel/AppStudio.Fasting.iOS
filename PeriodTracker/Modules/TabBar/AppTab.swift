//
//  AppTab.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI

enum AppTab: String {
    case tracker
    case nova
    case calendar

    var title: String {
        "AppTab.\(rawValue)".localized()
    }

    var icon: Image {
        switch self {
        case .tracker:
            Image(.circle)
        case .nova:
            Image(.nova)
        case .calendar:
            Image(.goal)
        }
    }
}
