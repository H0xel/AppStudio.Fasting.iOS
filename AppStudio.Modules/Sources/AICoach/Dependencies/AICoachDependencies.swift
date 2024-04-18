//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }

    var coachApi: CoachApi {
        self[CoachApiKey.self]!
    }
}

enum CoachApiKey: DependencyKey {
    static var liveValue: CoachApi?
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
}
