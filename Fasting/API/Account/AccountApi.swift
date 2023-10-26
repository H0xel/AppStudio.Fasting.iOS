//
//  AccountApi.swift
//  AppStudioApi
//
//  Created by Александр Alex on 12.12.17.
//  Copyright © 2017 GetPaid Inc. All rights reserved.
//

import Foundation
import MunicornAPI

/// Represents protocol for account service on server.
protocol AccountApi {
    /// Returns current account.
    /// - parameters:
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    func account() async throws -> Account
    /// Set current account.
    /// - parameters:
    ///     - account: account to be set.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    func set(account: Account) async throws -> Account
    /// Set current identifiers.
    /// - parameters:
    ///     - identifiers: identifiers to be set.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    func set(identifiers: Identifiers) async throws -> EmptyResult
    /// Deletes account.
    /// - parameters:
    ///     - accountId: account to be deleted.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    func delete(accountId: String, completion: @escaping CompletionCallback<EmptyResult>) -> RequestCancelable
}
