//  
//  ProfileCalculationServiceDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import Dependencies

extension DependencyValues {
    var profileCalculationServiceService: ProfileCalculationServiceService {
        self[ProfileCalculationServiceServiceKey.self]
    }
}

private enum ProfileCalculationServiceServiceKey: DependencyKey {
    static var liveValue: ProfileCalculationServiceService = ProfileCalculationServiceServiceImpl()
    static var testValue: ProfileCalculationServiceService = ProfileCalculationServiceServiceImpl()
}
