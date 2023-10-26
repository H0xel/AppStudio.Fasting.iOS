//
//  LateTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

final class LateTimeInitializers: Initializers {
    func initializers() -> [AppInitializer] {
        [
            AppCustomizationInitializer(),
            IntercomInitializer()
        ]
    }
}
