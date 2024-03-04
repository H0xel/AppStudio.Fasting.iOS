//
//  MigrationService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

import RxSwift

protocol MigrationService {
    func migrateIfNeeded() -> Observable<Void>
}
