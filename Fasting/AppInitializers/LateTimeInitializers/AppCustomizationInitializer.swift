//
//  AppCustomizationInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class AppCustomizationInitializer: AppInitializer {
    @Dependency(\.appCustomization) var appCustomization

    func initialize() {
        appCustomization.initialize()
    }
}
