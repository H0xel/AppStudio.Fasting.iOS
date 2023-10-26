//
//  MobileDeviceDataProviderInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class MobileDeviceDataProviderInitializer: AppInitializer {
    @Dependency(\.mobileDeviceDataProvider) var mobileDeviceDataProvider

    func initialize() {
        mobileDeviceDataProvider.initialize()
    }
}
