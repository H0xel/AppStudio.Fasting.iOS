//
//  AccountSyncServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 23.06.2023.
//

import Dependencies
import UIKit
import MunicornUtilities

class AccountSyncServiceImpl: SyncServiceBaseImpl<EmptyResult> {
    @Dependency(\.accountApi) private var accountApi
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.onboardingInitializer) private var onboardingInitializer

    override func syncRequest() async throws -> EmptyResult? {
        do {
            let result = try await accountApi.putAccount(
                PutAccountRequest(isProduction: !UIDevice.current.isSandbox,
                                  idfa: UIDevice.current.idfa,
                                  appsflyerId: analyticKeyStore.currentAppsFlyerId,
                                  firebaseId: analyticKeyStore.currentFirebaseId))
            onboardingInitializer.initialize()
            return result
        } catch {
            return try await retry()
        }
    }
}

// MARK: - AccountSyncService
extension AccountSyncServiceImpl: AccountSyncService {}
