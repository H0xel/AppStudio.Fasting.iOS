//
//  UserProviderInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import Dependencies

final class AccountProviderInitializer: AppInitializer {
    @Dependency(\.accountProvider) private var accountProvider

    func initialize() {
        accountProvider.initialize()
    }
}
