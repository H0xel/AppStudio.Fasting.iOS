//
//  UpdaterServiceDependencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

import Dependencies

extension DependencyValues {
    var appSyncService: AppSyncService {
        self[AppSyncServiceKey.self]
    }

    var accountSyncService: AccountSyncService {
        self[AccountSyncServiceKey.self]
    }
}

private enum AppSyncServiceKey: DependencyKey {
    static let liveValue: AppSyncService = AppSyncServiceImpl()
    static let testValue: AppSyncService = AppSyncServiceImpl()
}

private enum AccountSyncServiceKey: DependencyKey {
    static let liveValue: AccountSyncService = AccountSyncServiceImpl()
    static let testValue: AccountSyncService = AccountSyncServiceImpl()
}
