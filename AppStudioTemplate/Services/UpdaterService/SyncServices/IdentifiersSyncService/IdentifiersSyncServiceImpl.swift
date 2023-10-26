//
//  IdentifiersSyncServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 23.06.2023.
//

import UIKit
import Dependencies
import AppStudioFoundation
import MunicornUtilities

class IdentifiersSyncServiceImpl: SyncServiceBaseImpl<Identifiers> {
    @Dependency(\.accountApi) private var accountApi
    @Dependency(\.cloudStorage) private var cloudStorage

    override var shouldUpdate: Bool {
        guard let currentIdentifiers else {
            return false
        }
        return super.shouldUpdate && storageService.currentIdentifiers != currentIdentifiers
    }

    @discardableResult
    override func syncRequest() async throws -> Identifiers? {
        guard let currentIdentifiers else {
            return nil
        }

        do {
            try await accountApi.set(identifiers: currentIdentifiers)
            storageService.currentIdentifiers = currentIdentifiers
            return currentIdentifiers
        } catch {
            return try await retry()
        }
    }
}

// MARK: - IdentifiersSyncService
extension IdentifiersSyncServiceImpl: IdentifiersSyncService {
    private var currentIdentifiers: Identifiers? {
        guard let accountId = cloudStorage.accountId else {
            return nil
        }
        let id = UIDevice.current.isSandbox ? "stg_" + accountId : accountId
        return Identifiers(userId: id,
                           firebaseId: storageService.currentFirebaseId,
                           appsflyerId: storageService.currentAppsFlyerId,
                           idfa: UIDevice.current.idfa,
                           pushToken: nil) // TODO: fix when will push notification be implemented
    }
}

// MARK: - Migration
extension IdentifiersSyncServiceImpl: Migration {
    func migrate() async {
        do {
            try await syncRequest()
        } catch {}
    }
}
