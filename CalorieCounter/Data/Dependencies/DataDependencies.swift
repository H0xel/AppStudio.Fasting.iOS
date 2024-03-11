//
//  DataAssembly.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 02.11.2022.
//

import ABTesting
import MunicornFoundation
import Dependencies

extension DependencyValues {
    var preferencesService: PreferencesService {
        self[PreferencesServiceKey.self]
    }
}

private enum PreferencesServiceKey: DependencyKey {
    static let liveValue: PreferencesService = PreferencesServiceImpl()
    static let testValue: PreferencesService = PreferencesServiceImpl()
}
