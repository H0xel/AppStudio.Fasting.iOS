//
//  HealthProgressInitializer.swift
//
//
//  Created by Denis Khlopin on 08.03.2024.
//

import Foundation
import AppStudioAnalytics
import MunicornFoundation
import Dependencies

public class HealthProgressInitializer {

    public init() {}

    public func initialize(trackerService: TrackerService) {
        TrackerServiceKey.liveValue = trackerService
    }
}
