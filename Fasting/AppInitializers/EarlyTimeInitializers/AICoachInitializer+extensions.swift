//
//  AICoachInitializer+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies
import AICoach

extension AICoachInitializer: AppInitializer {
    func initialize() {
        @Dependency(\.trackerService) var trackerService
        @Dependency(\.storageService) var storageService
        @Dependency(\.userPropertyService) var userPropertyService
        initialize(styles: .fastingStyles,
                   trackerService: trackerService,
                   storageService: storageService,
                   userPropertyService: userPropertyService,
                   coachApi: CoachApiImpl())
    }
}

extension AICoachDatabaseInitializer: AppInitializer {}
