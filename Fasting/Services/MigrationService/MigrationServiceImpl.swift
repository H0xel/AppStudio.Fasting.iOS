//
//  MigrationServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

import RxSwift
import Foundation
import Dependencies

class MigrationServiceImpl: ServiceBaseImpl, MigrationService {

    @Dependency(\.storageService) private var storageService
    @Dependency(\.migrations) private var migrations
    private let appMigrationProvider: AppMigrationsProvider

    init(appMigrationsProvider: AppMigrationsProvider) {
        self.appMigrationProvider = appMigrationsProvider
    }

    func isMigrated(withId migrationId: String) -> Bool {
        storageService.get(key: "DataMigrations.\(migrationId)", defaultValue: false)
    }

    func setAsMigrated(id migrationId: String) {
        storageService.set(key: "DataMigrations.\(migrationId)", value: true)
    }

    public func migrateIfNeeded() -> Observable<Void> {
        invokeBlock { observer in
            Task { [weak self] in
                guard let self else {
                    observer.onCompleted()
                    return
                }
                var allMigrations = self.migrations
                allMigrations.append(contentsOf: self.appMigrationProvider.migrations)

                for migration in allMigrations where !self.isMigrated(withId: migration.id) {
                    await migration.migrate()
                    self.setAsMigrated(id: migration.id)
                }
                observer.onNext(())
                observer.onCompleted()
            }
        }
    }
}
