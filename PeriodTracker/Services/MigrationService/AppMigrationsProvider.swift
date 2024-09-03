//
//  AppMigrationsProvider.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

class AppMigrationsProvider {
    var migrations: [Migration]

    public init(migrations: [Migration]) {
        self.migrations = migrations
    }
}
