//
//  StorageService.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 02.11.2022.
//

import MunicornFoundation
import MunicornUtilities
import ABTesting
import Foundation

private let accountIdKey = "AppStudioApp.accountIdKey"
private let accessTokenKey = "AppStudioApp.accessToken"
private let currentAccountKey = "AppStudioApp.currentAccountKey"
private let firstLaunchRegisteredKey = "AppStudioApp.hasLaunchedOnceKey"
private let intercomUserIdKey = "AppStudioApp.intercomUserIdKey"
private let intercomUserHashKey = "AppStudioApp.intercomUserHashKey"
private let onboardingFinishedKey = "AppStudioApp.onboadrdingFinishedKey"

extension StorageService {
    var accountId: String? {
        get { get(key: accountIdKey) }
        set { set(key: accountIdKey, value: newValue) }
    }

    var accessToken: String? {
        get { get(key: accessTokenKey) }
        set { set(key: accessTokenKey, value: newValue) }
    }

    var firstLaunchRegistered: Bool {
        get { get(key: firstLaunchRegisteredKey, defaultValue: false) }
        set { set(key: firstLaunchRegisteredKey, value: newValue) }
    }

    var currentAccount: Account? {
        get {
            guard let json: String = get(key: currentAccountKey),
                  let account = try? Account(json: json) else {
                return nil
            }
            return account
        }
        set {
            set(key: currentAccountKey, value: newValue?.json())
        }
    }

    var intercomUserId: String? {
        get { return get(key: intercomUserIdKey) }
        set { set(key: intercomUserIdKey, value: newValue) }
    }

    var intercomUserHash: String? {
        get { return get(key: intercomUserHashKey) }
        set { set(key: intercomUserHashKey, value: newValue) }
    }

    var onboardingIsFinished: Bool {
        get { return get(key: onboardingFinishedKey, defaultValue: false) }
        set { set(key: onboardingFinishedKey, value: newValue) }
    }
}
