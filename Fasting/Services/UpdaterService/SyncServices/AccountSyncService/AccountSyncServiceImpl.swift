//
//  AccountSyncServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 23.06.2023.
//

import Dependencies
import UIKit

class AccountSyncServiceImpl: SyncServiceBaseImpl<EmptyResult> {
    @Dependency(\.accountApi) private var accountApi
    @Dependency(\.backendEnvironmentService) private var backendEnvironmentService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore

    override func syncRequest() async throws -> EmptyResult? {
        do {
            return try await accountApi.putAccount(
                PutAccountRequest(isProduction: backendEnvironmentService.currentEnvironment == .production,
                                  idfa: UIDevice.current.idfa,
                                  appsflyerId: analyticKeyStore.currentAppsFlyerId,
                                  firebaseId: analyticKeyStore.currentFirebaseId))
        } catch {
            return try await retry()
        }
    }
}

// MARK: - AccountSyncService
extension AccountSyncServiceImpl: AccountSyncService {}
