//  
//  CoachMessageRepositoryDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies

extension DependencyValues {
    var coachMessageRepository: CoachMessageRepository {
        self[CoachMessageRepositoryKey.self]
    }
}

private enum CoachMessageRepositoryKey: DependencyKey {
    static var liveValue: CoachMessageRepository = CoachMessageRepositoryImpl()
}
