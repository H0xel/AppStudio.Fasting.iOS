//
//  Contexts.swift
//  AppStudioTemplate
//
//  Created by Amakhin Ivan on 14.12.2023.
//

import AppStudioAnalytics

extension AnalyticEventType: TrackerParam {
    var description: String {
        return self.rawValue
    }
}

extension RestoreResult: TrackerParam {
    var description: String {
        return self.rawValue
    }
}
