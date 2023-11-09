//
//  UserProviderImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import Foundation
import Combine
import MunicornFoundation
import Dependencies
import AppStudioFoundation
import UIKit
import AppStudioAnalytics

final class AccountProviderImpl: AccountProvider {

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.storageService) private var storageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticStore

    private var lock = NSObject()
    private var currentAccountId: AuthId?
    private var currentAccessToken: AuthId?
    private var installationType: InstallationType = .notNew
    private var isInitialized = false
    private var cancellable: Cancellable?

    var accountId: AuthId {
        guard isInitialized, let currentAccountId else {
            fatalError("Must be initialized!")
        }
        return currentAccountId
    }
    var accessToken: AuthId {
        guard isInitialized, let currentAccessToken else {
            fatalError("Must be initialized!")
        }
        return currentAccessToken
    }

    init() {
        subscribeToAccountCredentialsChangedNotification()
    }

    func initialize() {
        configure()
        isInitialized = true
    }

    private func subscribeToAccountCredentialsChangedNotification() {
        cancellable = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .filter { [weak self] notification in
                guard let self,
                      let changedKeys = notification.userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [Any],
                      self.storageService.firstLaunchRegistered else {
                    return false
                }
                let changedKeysString = changedKeys.map { $0 as? String }
                return changedKeysString.contains(where: { ($0 == accountIdKey) || ($0 == accessTokenKey) })
            }
            .sink { [weak self] _ in
                self?.configure()
            }
    }

    private func configure() {
        synchronized(lock) {
            configureAccountId()
            configureAccessToken()
        }
    }

    private func configureAccountId() {
        if let accountIdStr = cloudStorage.accountId {
            currentAccountId = AuthId(secret: accountIdStr)
            storageService.accountId = accountIdStr
            installationType = .notNew
        } else if let accountId = storageService.accountId {
            currentAccountId = AuthId(secret: accountId)
            cloudStorage.accountId = accountId
            installationType = .notNew
        } else {
            let accountId = AuthId()
            currentAccountId = accountId
            cloudStorage.accountId = accountId.secret
            storageService.accountId = accountId.secret
            installationType = .new
        }
    }

    private func configureAccessToken() {
        if let accessTokenStr = cloudStorage.accessToken {
            currentAccessToken = AuthId(secret: accessTokenStr)
            storageService.accessToken = accessTokenStr
        } else if let accessToken = storageService.accessToken {
            currentAccessToken = AuthId(secret: accessToken)
            cloudStorage.accessToken = accessToken
        } else {
            let accessToken = AuthId()
            currentAccessToken = accessToken
            cloudStorage.accessToken = accessToken.secret
            storageService.accessToken = accessToken.secret
        }
    }
}

private let accountIdKey = "AppStudioApp.iCloud.accountIdKey"
private let accessTokenKey = "AppStudioApp.iCloud.accessTokenKey"

extension CloudStorage {
    var accountId: String? {
        get { get(key: accountIdKey) }
        set { set(key: accountIdKey, value: newValue) }
    }

    var accessToken: String? {
        get { get(key: accessTokenKey) }
        set { set(key: accessTokenKey, value: newValue) }
    }
}
