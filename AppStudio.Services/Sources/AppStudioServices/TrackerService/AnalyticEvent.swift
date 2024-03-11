//
//  File.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import UIKit
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case testValue
    var name: String {
        switch self {
        case .testValue: return "Test value"
        }
    }

    var forAppsFlyer: Bool { false }
}
