//
//  MobileDeviceDataProviderPreview.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.05.2023.
//

import MunicornFoundation

class AppStudioMobileDeviceDataProviderPreview: AppStudioMobileDeviceDataProvider {
    var isNewInstall = false
    var deviceData: MobileDeviceProperties {
        .mock
    }

    func initialize() {}
}
