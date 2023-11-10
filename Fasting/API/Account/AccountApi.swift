//
//  AccountApi.swift
//  AppStudioApi
//
//  Created by Александр Alex on 12.12.17.
//  Copyright © 2017 GetPaid Inc. All rights reserved.
//


protocol AccountApi {
    func account() async throws -> Account
    func putAccount(_ accout: PutAccountRequest) async throws -> EmptyResult
    @discardableResult
    func putPushToken(_ token: PutPushTokenRequest) async throws -> EmptyResult
}
