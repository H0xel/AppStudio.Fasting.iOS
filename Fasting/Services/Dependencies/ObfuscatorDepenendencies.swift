//
//  ObfuscatorDepenendencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.05.2023.
//

import MunicornFoundation
import Dependencies

extension DependencyValues {
    public var obfuscator: Obfuscator {
        self[ObfuscatorKey.self]
    }
}

private enum ObfuscatorKey: DependencyKey {
    static var liveValue = DependencyContainer.container.obfuscator(withSalt: ["String", "Data", "AppDelegate"])
}
