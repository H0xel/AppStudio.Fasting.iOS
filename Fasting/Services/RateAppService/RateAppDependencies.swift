//  
//  RateAppDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 09.07.2024.
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
