//
//  ApiDependencies.swift
//  AppStudio
//
//  Created by Denis Khlopin on 25.01.2023.
//

import UIKit
import Dependencies
import NewAppStudioSubscriptions
import MunicornUtilities

extension DependencyValues {

    var apiSettingsProvider: AppStudioApiSettingsProvider {
        self[AppStudioApiSettingsProviderKey.self]
    }

    var accountApi: AccountApi {
        self[AccountApiKey.self]
    }

    var subscriptionApi: SubscriptionApi {
        self[SubscriptionApiKey.self]
    }
}

private enum AppStudioApiSettingsProviderKey: DependencyKey {
    static var liveValue: AppStudioApiSettingsProvider {
        UIDevice.current.isSandbox ? SandBoxApiSettingsProvider() : ApiSettingsProviderImpl()
    }
}

private enum AccountApiKey: DependencyKey {
    static let liveValue: AccountApi = AccountApiImpl()
}

private enum SubscriptionApiKey: DependencyKey {
    static let liveValue: SubscriptionApi = SubscriptionsApiImpl()
}
