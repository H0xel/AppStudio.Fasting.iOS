//
//  SandBoxApiSettingsProvider.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 04.09.2023.
//

import Dependencies

final class SandBoxApiSettingsProvider: AppStudioApiSettingsProvider {
    @Dependency(\.storageService) private var storageService
    public var baseAddress: String {
        storageService.environment == .production
        ? GlobalConstants.productionBaseAddress
        : GlobalConstants.sandboxBaseAddress
    }
    public let servicePath = GlobalConstants.sandboxServicePath
    public let timeout = GlobalConstants.sandboxTimeout
}
