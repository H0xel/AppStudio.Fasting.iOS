//
//  AppTemplateManager.swift
//  Fasting
//
//  Created by Alexander Bochkarev on 23.10.2023.
//

import Foundation

final class AppTemplateManager {

    static let isAppTemplate: Bool = {
        UserDefaults.standard.bool(forKey: "isAppTemplate")
    }()

    private init() {}
}
