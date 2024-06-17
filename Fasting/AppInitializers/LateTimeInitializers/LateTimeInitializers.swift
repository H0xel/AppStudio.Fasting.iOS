//
//  LateTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//
import Dependencies

final class LateTimeInitializers: Initializers {
    @Dependency(\.productProviderInitializer) private var productProviderInitializer
    func initializers() -> [AppInitializer] {
        [
            NewSubscriptionInitializerService(),
            AppCustomizationInitializer(),
            productProviderInitializer,
            IntercomInitializer()
        ]
    }
}
