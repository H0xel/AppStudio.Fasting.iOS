//  
//  WaterSettingsRepositoryDependencies.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import Dependencies

extension DependencyValues {
    var waterSettingsRepository: WaterSettingsRepository {
        self[WaterSettingsRepositoryKey.self]
    }
}

private enum WaterSettingsRepositoryKey: DependencyKey {
    static var liveValue: WaterSettingsRepository = WaterSettingsRepositoryImpl()
}
