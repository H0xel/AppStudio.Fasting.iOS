//
//  MigrationLaunchService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

import RxSwift

protocol MigrationLaunchService {
    func migrateObservable() -> Observable<Void>
}
