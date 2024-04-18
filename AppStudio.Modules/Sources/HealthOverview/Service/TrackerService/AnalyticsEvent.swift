//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 26.03.2024.
//

import Foundation
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case tapProfile
    case tapDate(date: String)
    case tapNextDay(targetDate: String)
    case tapPreviousDay(targetDate: String)
    case swipeWeek(direction: String)
    case swipeDay(direction: String)
    case tapUpdateWeight(date: String, today: Bool)
    case weightUpdated(date: String)
    case tapBackToToday

    var name: String {
        switch self {
        case .tapProfile: "Tap profile"
        case .tapDate: "Tap date"
        case .tapNextDay: "Tap next day"
        case .tapPreviousDay: "Tap previous day"
        case .swipeWeek: "Swipe week"
        case .tapUpdateWeight: "Tap update weight"
        case .weightUpdated: "Weight updated"
        case .tapBackToToday: "Tap back to today"
        case .swipeDay: "Swipe day"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
