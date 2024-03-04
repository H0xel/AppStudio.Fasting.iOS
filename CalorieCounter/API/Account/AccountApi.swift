//
//  AccountApi.swift
//  AppStudioApi
//
//  Created by Konstantin Golenkov on 30.10.2023.
//

protocol AccountApi {
    func account() async throws -> Account
    func putAccount(_ accout: PutAccountRequest) async throws -> EmptyResult
    @discardableResult
    func putPushToken(_ token: PutPushTokenRequest) async throws -> EmptyResult
}
