//
//  AppSettingsProviderImpl.swift
//  AppStudio
//
//  Created by Руслан Сафаргалеев on 14.06.2023.
//

struct AppSettingsProviderImpl: AppSettingsProvider {
    var termsOfUse: String { GlobalConstants.termsOfUse }
    var privacyPolicy: String { GlobalConstants.privacyPolicy }
}
