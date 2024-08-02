//
//  ServicesDependencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//

import RxSwift
import Dependencies
import AppStudioFoundation
import MunicornAPI
import UIKit

extension DependencyValues {
    var migrations: [Migration] {
        [
            MealtItemMigration(),
            PutReceiptMigrationForUsersWithActualSubscription()
        ]
    }
    var migrationLaunchService: MigrationLaunchService {
        self[MigrationLaunchServiceKey.self]
    }

    var appSettingsProvider: AppSettingsProvider {
        self[AppSettingsProviderKey.self]
    }

    var backendEnvironmentService: BackendEnvironmentService {
        self[BackendEnvironmentServiceKey.self]
    }
}

private enum BackendEnvironmentServiceKey: DependencyKey {
	static var liveValue = BackendEnvironmentService()
}

private enum AppSettingsProviderKey: DependencyKey {
    static var liveValue = AppSettingsProviderImpl()
}

private enum MigrationLaunchServiceKey: DependencyKey {
    static var liveValue: MigrationLaunchService = MigrationLaunchServiceImpl(
        migrationService: MigrationServiceKey.liveValue
    )
}

private enum MigrationServiceKey: DependencyKey {
    static var liveValue: MigrationService = MigrationServiceImpl(
        appMigrationsProvider: AppMigrationsProviderKey.liveValue
    )
}

private enum AppMigrationsProviderKey: DependencyKey {
    static var liveValue = AppMigrationsProvider(migrations: [])
}
