//  
//  CoachDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import Dependencies

public extension DependencyValues {
    var coachService: CoachService {
        self[CoachServiceKey.self]
    }
}

private enum CoachServiceKey: DependencyKey {
    static var liveValue: CoachService = CoachServiceImpl()
}
