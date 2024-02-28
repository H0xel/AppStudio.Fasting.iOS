//
//  CoachConstants.swift
//
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import Foundation

public struct CoachConstants {
    let privacyPolicy: String
    let termsOfUse: String
    let appName: String

    public init(privacyPolicy: String, termsOfUse: String, appName: String) {
        self.privacyPolicy = privacyPolicy
        self.termsOfUse = termsOfUse
        self.appName = appName
    }
}
