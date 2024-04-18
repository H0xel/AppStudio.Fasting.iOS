//  
//  RateAppDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import Dependencies

extension DependencyValues {
    var rateAppService: RateAppService {
        self[RateAppServiceKey.self]
    }
}

private enum RateAppServiceKey: DependencyKey {
    static var liveValue: RateAppService = RateAppServiceImpl()
}
