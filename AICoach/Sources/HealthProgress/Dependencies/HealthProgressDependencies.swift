//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var trackerService: TrackerService {
        self[TrackerServiceKey.self]!
    }
}

enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService?
}
