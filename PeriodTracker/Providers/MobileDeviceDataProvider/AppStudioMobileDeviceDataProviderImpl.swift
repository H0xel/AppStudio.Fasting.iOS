//
//  MobileDeviceDataProviderImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.05.2023.
//

import Foundation
import RxSwift
import SwiftUI
import MunicornFoundation
import MunicornUtilities
import Dependencies

final class AppStudioMobileDeviceDataProviderImpl: AppStudioMobileDeviceDataProvider {

    @Dependency(\.storageService) private var storageService

    // do not use
    var isNewInstall = false

    private var isInitialized = false

    var deviceData: MobileDeviceProperties {
        guard isInitialized else {
            fatalError("Must be initialized!")
        }
        return MobileDeviceProperties(appType: GlobalConstants.applicationName,
                                      store: storeName,
                                      id: UIDevice.current.identifierForVendor?.uuidString ?? "",
                                      osType: "ios",
                                      osVersion: UIDevice.current.systemVersion,
                                      deviceName: UIDevice.current.name,
                                      deviceMake: "Apple",
                                      deviceModelCode: UIDevice.current.model,
                                      deviceModel: UIDevice.current.modelName,
                                      timezone: NSTimeZone.local.secondsFromGMT(),
                                      appVersion: Bundle.appVersion,
                                      appBuildNumber: Bundle.bundleVersion,
                                      apiVersion: "3")
    }

    func initialize() {
        guard !isInitialized else {
            assertionFailure("Should call initialize() only once!")
            return
        }
        isInitialized = true
    }

    private var storeName: String = {
        #if DEBUG
        return "debug"
        #else
        if UIDevice.current.isSandbox {
            return "testflight"
        } else {
            return "appstore"
        }
        #endif
    }()
}
