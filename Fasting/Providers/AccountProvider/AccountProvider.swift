//
//  UserProvider.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 11.07.2023.
//

import MunicornFoundation

typealias AuthId = DeviceId

protocol AccountProvider {
    var accountId: AuthId { get }
    var accessToken: AuthId { get }

    func initialize()
}
