//
//  ApiSettingsProviderImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

import Dependencies

final class ApiSettingsProviderImpl: AppStudioApiSettingsProvider {
    let baseAddress = GlobalConstants.productionBaseAddress
    let servicePath = GlobalConstants.productionServicePath
    let timeout = GlobalConstants.productionTimeout
    lazy var sharedParameter: String = { obfuscator.reveal(key: obfuscatedSharedParameter) }()

    private let obfuscatedSharedParameter = GlobalConstants.productionObfuscatedSharedParameter
    @Dependency(\.obfuscator) private var obfuscator
}
