//
//  AppInitializerServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 24.05.2023.
//

import RxSwift
import Dependencies

final class AppInitializerServiceImpl: AppInitializerService {
    @Dependency(\.messengerService) private var messengerService
    @Dependency(\.migrationLaunchService) private var migrationLaunchService
    @Dependency(\.earlyTimeInitializers) private var earlyTimeInitializers
    @Dependency(\.lateTimeInitializers) private var lateTimeInitializers
    private let disposeBag = DisposeBag()

    func initialize() {
        earlyInitializersInitialization()
        messengerService.publish(message: AppInitializedMessage(sender: self))
        migrationLaunchService
            .migrateObservable()
            .subscribe(with: self) { this, _ in
                this.migrationDidFinish()
            }
            .disposed(by: disposeBag)
    }

    private func migrationDidFinish() {
        messengerService.publishMigrationFinishedMessage(sender: self)
        lateInitializersInitialization()
    }

    private func earlyInitializersInitialization() {
        earlyTimeInitializers.initializers().forEach { initializer in
            initializer.initialize()
        }
    }

    private func lateInitializersInitialization() {
        lateTimeInitializers.initializers().forEach { initializer in
            initializer.initialize()
        }
    }
}
