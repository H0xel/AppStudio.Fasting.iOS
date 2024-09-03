//
//  AccountIdProviderImpl.swift
//  AppStudioTemplate
//
//  Created by Konstantin Golenkov on 24.10.2023.
//

import Foundation
import MunicornFoundation
import Dependencies

final class AccountIdProviderImpl: AccountIdProvider {

    @Dependency(\.accountProvider) private var accountProvider

    var accountId: String {
        accountProvider.accountId
    }
}
