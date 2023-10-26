//
//  ProvidersDependencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import UIKit
import MunicornFoundation
import Dependencies

extension DependencyValues {
    var mobileDeviceDataProvider: AppStudioMobileDeviceDataProvider {
        self[AppStudioMobileDeviceDataProviderKey.self]
    }

    var accountProvider: AccountProvider {
        self[AccountProviderKey.self]
    }

    var accountIdProvider: AccountIdProvider {
        self[AccountIdProviderKey.self]
    }
}

private enum AppStudioMobileDeviceDataProviderKey: DependencyKey {
    public static var liveValue: AppStudioMobileDeviceDataProvider = AppStudioMobileDeviceDataProviderImpl()
    public static var previewValue: AppStudioMobileDeviceDataProvider = AppStudioMobileDeviceDataProviderPreview()
}

private enum AccountProviderKey: DependencyKey {
    public static var liveValue: AccountProvider = AccountProviderImpl()
    public static var previewValue: AccountProvider = AccountProviderPreview()
}

private enum AccountIdProviderKey: DependencyKey {
    public static var liveValue: AccountIdProvider = AccountIdProviderImpl()
}
