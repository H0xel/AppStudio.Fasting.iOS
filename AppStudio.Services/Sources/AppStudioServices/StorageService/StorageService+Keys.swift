//
//  StorageService+Keys.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import MunicornFoundation
import Foundation

private let accountIdKey = "AppStudioApp.accountIdKey"
private let accessTokenKey = "AppStudioApp.accessToken"
private let firstLaunchRegisteredKey = "AppStudioApp.hasLaunchedOnceKey"
private let intercomUserIdKey = "AppStudioApp.intercomUserIdKey"
private let intercomUserHashKey = "AppStudioApp.intercomUserHashKey"

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

    var intercomUserId: String? {
        get { return get(key: intercomUserIdKey) }
        set { set(key: intercomUserIdKey, value: newValue) }
    }

    var intercomUserHash: String? {
        get { return get(key: intercomUserHashKey) }
        set { set(key: intercomUserHashKey, value: newValue) }
    }
}
