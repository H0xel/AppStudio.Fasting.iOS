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
        initialize(styles: .fastingStyles,
                   coachApi: CoachApiImpl())
    }
}

extension AICoachDatabaseInitializer: AppInitializer {}
