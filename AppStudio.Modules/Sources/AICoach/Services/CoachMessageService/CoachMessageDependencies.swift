//  
//  CoachMessageDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies

extension DependencyValues {
    var coachMessageService: CoachMessageService {
        self[CoachMessageServiceKey.self]
    }
}

private enum CoachMessageServiceKey: DependencyKey {
    static var liveValue: CoachMessageService = CoachMessageServiceImpl()
}
