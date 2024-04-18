//
//  File.swift
//  
//
//  Created by Denis Khlopin on 08.03.2024.
//

import Foundation
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case tapInfo(context: String, source: String, target: String)
    case tapWaterSettings(context: String)
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .tapInfo: "Tap info"
        case .tapWaterSettings: "Tap water settings"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
