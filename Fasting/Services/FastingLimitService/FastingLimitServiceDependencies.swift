//
//  FastingLimitServiceDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 24.11.2023.
//

import Dependencies

extension DependencyValues {
    var fastingFinishedCyclesLimitService: FastingLimitService {
        self[FastingFinishedCyclesLimitServiceKey.self]
    }
}

private enum FastingFinishedCyclesLimitServiceKey: DependencyKey {
    static var liveValue: FastingLimitService = FastingFinishedCyclesLimitServiceImpl()
    static var testValue: FastingLimitService = FastingFinishedCyclesLimitServiceImpl()
    static var previewValue: FastingLimitService = FastingFinishedCyclesLimitServiceImpl()
}
