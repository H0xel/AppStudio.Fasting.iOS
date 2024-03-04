//
//  ApiSettingsProviderImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

final class ApiSettingsProviderImpl: AppStudioApiSettingsProvider {
    let baseAddress = GlobalConstants.productionBaseAddress
    let servicePath = GlobalConstants.productionServicePath
    let timeout = GlobalConstants.productionTimeout
}
