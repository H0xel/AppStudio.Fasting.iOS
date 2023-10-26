//
//  AccountSyncServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 23.06.2023.
//

import Foundation
import Dependencies
import MunicornAPI

private let errorCodeVersionMismatch = "version_mismatch"
private let errorCodeNotFound = "not_found"

class AccountSyncServiceImpl: SyncServiceBaseImpl<Account> {
    @Dependency(\.accountApi) private var accountApi
    @Dependency(\.intercomDataStorage) private var intercomDataStorage

    override var shouldUpdate: Bool {
        guard currentAccount != nil else {
            return false
        }
        return super.shouldUpdate
    }

    override func syncRequest() async throws -> Account? {
        guard let currentAccount else {
            return try await retry()
        }
        do {
            let account = try await accountApi.set(account: currentAccount)
            saveAccountToStorage(account)
            return account
        } catch {
            if let error = error as? InvokeResultError,
               error.resultCode == errorCodeVersionMismatch {
                await accountFromServer()
                return try await retry()
            }
            return try await retry()
        }
    }
}

// MARK: - AccountSyncService
extension AccountSyncServiceImpl: AccountSyncService {

    @discardableResult
    func accountFromServer() async -> Account? {
        do {
            let serverAccount = try await accountApi.account()
            saveAccountToStorage(serverAccount)
            return serverAccount
        } catch {
            if let error = error as? InvokeResultError,
               error.resultCode == errorCodeNotFound {
                saveAccountToStorage(nil)
            }
            return nil
        }
    }
}

// MARK: - private functions
extension AccountSyncServiceImpl {
    private func saveAccountToStorage(_ account: Account?) {
        storageService.currentAccount = account
        if let intercomData = account?.intercom {
            storageService.intercomUserId = intercomData.userId
            storageService.intercomUserHash = intercomData.hash
            intercomDataStorage.sync(userId: intercomData.userId, hash: intercomData.hash)
        }
    }

    private var currentAccount: Account? {
        storageService.currentAccount
    }
}
