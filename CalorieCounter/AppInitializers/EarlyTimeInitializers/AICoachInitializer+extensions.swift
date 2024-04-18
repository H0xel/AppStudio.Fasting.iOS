//
//  AICoachInitializer+extensions.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.04.2024.
//

import Foundation

import Dependencies
import AICoach

extension AICoachInitializer: AppInitializer {
    func initialize() {
        initialize(styles: .fastingStyles,
                   coachApi: CoachApiImpl())
    }
}

extension AICoachDatabaseInitializer: AppInitializer {}
