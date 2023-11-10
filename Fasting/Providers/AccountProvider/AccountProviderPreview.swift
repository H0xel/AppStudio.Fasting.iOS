//
//  UserProviderPreview.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import Foundation

final class AccountProviderPreview: AccountProvider {

    var accountId: String {
        UUID().uuidString
    }

    var accessToken: String {
        UUID().uuidString
    }

    func initialize() {}
}
