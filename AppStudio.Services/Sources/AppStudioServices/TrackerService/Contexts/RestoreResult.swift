//
//  RestoreResult.swift
//
//
//  Created by Amakhin Ivan on 29.04.2024.
//

import AppStudioAnalytics
import Foundation

enum RestoreResult: String {
    case success
    case fail
}

extension RestoreResult: TrackerParam {
    public var description: String {
        return self.rawValue
    }
}
