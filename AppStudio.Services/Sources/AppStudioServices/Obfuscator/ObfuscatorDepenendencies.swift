//
//  File.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
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
