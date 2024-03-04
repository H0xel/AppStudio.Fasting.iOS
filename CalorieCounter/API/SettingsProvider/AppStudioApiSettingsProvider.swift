//
//  AppStudioApiSettingsProvider.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

protocol AppStudioApiSettingsProvider {
    var baseAddress: String { get }
    var servicePath: String { get }
    var timeout: Double { get }
}
