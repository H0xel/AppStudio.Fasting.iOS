//
//  PreferencesService.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 23.10.2023.
//

protocol PreferencesService {
    var isStagingEnabled: Bool { get }

    func initialize()
}
