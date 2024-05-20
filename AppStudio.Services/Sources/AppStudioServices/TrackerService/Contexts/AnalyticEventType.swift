//
//  AnalyticEventType.swift
//
//
//  Created by Amakhin Ivan on 29.04.2024.
//

import AppStudioAnalytics
import Foundation

enum AnalyticEventType: String {
    case main
    case promo
}

extension AnalyticEventType: TrackerParam {
    public var description: String {
        return self.rawValue
    }
}
