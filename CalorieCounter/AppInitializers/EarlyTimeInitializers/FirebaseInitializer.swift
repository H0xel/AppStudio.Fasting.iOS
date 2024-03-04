//
//  FirebaseInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import FirebaseCore

final class FirebaseInitializer: AppInitializer {

    func initialize() {
        FirebaseApp.configure()
    }
}
