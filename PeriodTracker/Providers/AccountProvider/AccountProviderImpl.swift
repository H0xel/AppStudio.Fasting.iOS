//
//  UserProviderImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import UIKit
import Combine
import MunicornFoundation
import Dependencies
import AppStudioFoundation

final class AccountProviderImpl: AccountProvider {

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.storageService) private var storageService

    private var lock = NSObject()
    private var currentAccountId: String?
    private var currentAccessToken: String?
    private var installationType: InstallationType = .notNew
    private var isInitialized = false
    private var cancellable: Cancellable?

    var accountId: String {
        guard isInitialized, let currentAccountId else {
            fatalError("Must be initialized!")
        }
        return currentAccountId
    }
    var accessToken: String {
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
            currentAccountId = accountIdStr
            storageService.accountId = accountIdStr
            installationType = .notNew
        } else if let accountId = storageService.accountId {
            currentAccountId = accountId
            cloudStorage.accountId = accountId
            installationType = .notNew
        } else {
            let accountId = UUID().uuidString
            currentAccountId = accountId
            cloudStorage.accountId = accountId
            storageService.accountId = accountId
            installationType = .new
        }
    }

    private func configureAccessToken() {
        if let accessTokenStr = cloudStorage.accessToken {
            currentAccessToken = accessTokenStr
            storageService.accessToken = accessTokenStr
        } else if let accessToken = storageService.accessToken {
            currentAccessToken = accessToken
            cloudStorage.accessToken = accessToken
        } else {
            let accessToken = UUID().uuidString
            currentAccessToken = accessToken
            cloudStorage.accessToken = accessToken
            storageService.accessToken = accessToken
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
