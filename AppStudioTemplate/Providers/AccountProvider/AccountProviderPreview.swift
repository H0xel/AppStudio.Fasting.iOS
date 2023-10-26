//
//  UserProviderPreview.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

final class AccountProviderPreview: AccountProvider {

    var accountId: AuthId {
        AuthId()
    }

    var accessToken: AuthId {
        AuthId()
    }

    func initialize() {}
}
