//
//  BusinessAccountProviderInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import Dependencies

final class BusinessAccountProviderInitializer: AppInitializer {
    @Dependency(\.businessAccountProvider) private var businessAccountProvider

    func initialize() {
        businessAccountProvider.initialize()
    }
}
