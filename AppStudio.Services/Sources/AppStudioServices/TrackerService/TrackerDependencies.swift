//  
//  TrackerDependencies.swift
//  
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies
import AppStudioAnalytics

public extension DependencyValues {
    var trackerService: TrackerService {
        guard let trackerService = self[TrackerServiceKey.self] else {
            fatalError("subscriptionService dependency is not registred!")
        }
        return trackerService
    }
}

public enum TrackerServiceKey: DependencyKey {
    public static var liveValue: TrackerService?
}
