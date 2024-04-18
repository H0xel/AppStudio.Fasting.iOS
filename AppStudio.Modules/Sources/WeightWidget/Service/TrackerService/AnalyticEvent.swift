//
//  AnalyticEvent.swift
//
//
//  Created by Руслан Сафаргалеев on 26.03.2024.
//

import Foundation
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case tapInfo(context: String, source: String, target: String)
    case tapUpdateWeight(date: String, today: Bool)
    case weightUpdated(date: String)
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .tapInfo: "Tap info"
        case .tapUpdateWeight: "Tap update weight"
        case .weightUpdated: "Weight updated"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
