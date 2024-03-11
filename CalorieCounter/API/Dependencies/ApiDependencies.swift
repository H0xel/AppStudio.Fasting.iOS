//
//  ApiDependencies.swift
//  AppStudio
//
//  Created by Denis Khlopin on 25.01.2023.
//

import Foundation
import Dependencies
import AppStudioSubscriptions
import MunicornUtilities
import UIKit

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

    var calorieCounterApi: CalorieCounterApi {
        self[CalorieCounterApiKey.self]
    }
}

private enum AppStudioApiSettingsProviderKey: DependencyKey {
    static var liveValue: AppStudioApiSettingsProvider {
        UIDevice.current.isSandbox ? SandBoxApiSettingsProvider() : ApiSettingsProviderImpl()
    }
}

private enum CalorieCounterApiKey: DependencyKey {
    static let liveValue = CalorieCounterApiImpl()
}

private enum AccountApiKey: DependencyKey {
    static let liveValue: AccountApi = AccountApiImpl()
}

private enum SubscriptionApiKey: DependencyKey {
    static let liveValue: SubscriptionApi = SubscriptionsApiImpl()
}

// TODO: TEMP if we want to track server errors we need to implement it and remove mocking
// private class MockAPITracker: ApiTracker {
//     func serverError(code: String, message: String?) {
//         print("Code: \(code) - Error: \(message ?? "")")
//     }
// }