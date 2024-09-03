//
//  MigrationLaunchServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

import RxSwift

final class MigrationLaunchServiceImpl: MigrationLaunchService {

    private let migrationService: MigrationService

    init(migrationService: MigrationService) {
        self.migrationService = migrationService
    }

    public func migrateObservable() -> Observable<Void> {
        migrationService.migrateIfNeeded()
    }
}
