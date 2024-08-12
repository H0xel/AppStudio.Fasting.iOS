//  
//  RootInitializationDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.08.2024.
//

import Dependencies

extension DependencyValues {
    var rootInitializationService: RootInitializationService {
        self[RootInitializationServiceKey.self]
    }
}

private enum RootInitializationServiceKey: DependencyKey {
    static var liveValue: RootInitializationService = RootInitializationServiceImpl()
    static var testValue: RootInitializationService = RootInitializationServiceImpl()
    static var previewValue: RootInitializationService = RootInitializationServiceImpl()
}
