//
//  ApiDependencies.swift
//  AppStudio
//
//  Created by Denis Khlopin on 25.01.2023.
//

import Foundation
import Dependencies
import MunicornAPI
import UIKit

extension DependencyValues {

    var baseApi: ApiImplBase {
        self[ApiImplBaseKey.self]
    }

    var apiSettingsProvider: AppStudioApiSettingsProvider {
        self[AppStudioApiSettingsProviderKey.self]
    }

    var accountApi: AccountApi {
        self[AccountApiKey.self]
    }
}

private enum ApiImplBaseKey: DependencyKey {
    static var liveValue: ApiImplBase {
        @Dependency(\.mobileDeviceDataProvider) var deviceDataProvider
        @Dependency(\.apiSettingsProvider) var settingsProvider
        @Dependency(\.accountIdProvider) var accountIdProvider

        return ApiImplBase(deviceDataProvider: deviceDataProvider,
                           settingsProvider: settingsProvider,
                           tracker: MockAPITracker(),
                           accountIdProvider: accountIdProvider)
    }
}

private enum AppStudioApiSettingsProviderKey: DependencyKey {
    static var liveValue: AppStudioApiSettingsProvider {
        @Dependency(\.backendEnvironmentService) var backendEnvironmentService
        switch backendEnvironmentService.currentEnvironment {
        case .production:
            return ApiSettingsProviderImpl()
        case .staging:
            return SandBoxApiSettingsProvider()
        }
    }
}

private enum AccountApiKey: DependencyKey {
    static var liveValue: AccountApi = AccountApiImpl()
}

// TODO: TEMP if we want to track server errors we need to implement it and remove mocking
private class MockAPITracker: ApiTracker {
    func serverError(code: String, message: String?) {
        print("Code: \(code) - Error: \(message ?? "")")
    }
}
