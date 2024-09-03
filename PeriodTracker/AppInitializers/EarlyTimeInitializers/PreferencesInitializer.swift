//
//  PreferencesInitializer.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 23.10.2023.
//

import Dependencies

final class PreferencesInitializer: AppInitializer {

    @Dependency(\.preferencesService) private var preferencesService

    func initialize() {
        preferencesService.initialize()
    }
}
