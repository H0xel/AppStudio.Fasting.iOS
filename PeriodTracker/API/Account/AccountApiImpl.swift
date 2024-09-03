//
//  AccountApiImpl.swift
//  AppStudioApi
//
//  Created by Konstantin Golenkov on 30.10.2023.
//

import Moya
import Foundation
import Dependencies

class AccountApiImpl: AccountApi {

    private let provider = TelecomApiProvider<AccountTarget>()

    func account() async throws -> Account {
        // TODO: implement
        Account()
    }

    func putAccount(_ accout: PutAccountRequest) async throws -> EmptyResult {
        try await provider.request(.putAccount(accout))
    }

    func putPushToken(_ token: PutPushTokenRequest) async throws -> EmptyResult {
        try await provider.request(.putPushToken(token))
    }
}
