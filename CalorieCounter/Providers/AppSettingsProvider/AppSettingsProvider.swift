//
//  AppSettingsProvider.swift
//  ModuleCommon
//
//  Created by Konstantin Golenkov on 27.01.2023.
//

public protocol AppSettingsProvider {
    var termsOfUse: String { get }
    var privacyPolicy: String { get }
}
