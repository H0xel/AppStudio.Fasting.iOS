//
//  PreferencesServiceImpl.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 23.10.2023.
//

import Dependencies
import Foundation

final class PreferencesServiceImpl: PreferencesService {

    enum PreferenceKey: String {
        case stagingEnabled = "staging_enabled"
    }

    var isStagingEnabled: Bool {
        UserDefaults.standard.bool(forKey: PreferenceKey.stagingEnabled.rawValue)
    }

    func initialize() {
        // this function writes default settings as settings
        guard let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") else {
            return
        }
        var settings = NSDictionary(contentsOfFile: settingsBundle.appending("/Root.plist"))!
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: Any]] else {
            return
        }
        var defaults: [String: Any] = [:]
        for preference in preferences {
            if let key = preference["Key"] as? String {
                defaults[key] = preference["DefaultValue"]
            }
        }
        UserDefaults.standard.register(defaults: defaults)
    }
}
