//
//  AccountApiImpl.swift
//  AppStudioApi
//
//  Created by Александр Alex on 12.12.17.
//  Copyright © 2017 GetPaid Inc. All rights reserved.
//

import MunicornAPI
import Dependencies

class AccountApiImpl: AccountApi {

    @Dependency(\.baseApi) var baseApi

    /// Returns current account.
    /// - parameters:
    ///     - completion: completion callback.
    /// - returns: Account object
    func account() async throws -> Account {
        try await withCheckedThrowingContinuation { continuation in
            account { result in
                if result.isFailure, let errorInfo = result.userMessage {
                    continuation.resume(throwing: InvokeResultError(errorInfo: errorInfo))
                    return
                }

                if result.isSuccess, let account = result.data {
                    continuation.resume(returning: account)
                    return
                }
            }
        }
    }
    /// Set current account.
    /// - parameters:
    ///     - account: account to be set.
    /// - returns: Account object.
    func set(account: Account) async throws -> Account {
        try await withCheckedThrowingContinuation { continuation in
            set(account: account) { result in
                if result.isFailure, let errorInfo = result.userMessage {
                    continuation.resume(throwing: InvokeResultError(errorInfo: errorInfo))
                    return
                }

                if result.isSuccess, let account = result.data {
                    continuation.resume(returning: account)
                    return
                }
            }
        }
    }
    /// Set current identifiers.
    /// - parameters:
    ///     - identifiers: identifiers to be set.
    /// - returns: EmptyResult object id succeed.
    func set(identifiers: Identifiers) async throws -> EmptyResult {
        try await withCheckedThrowingContinuation { continuation in
            set(identifiers: identifiers) { result in
                if result.isFailure, let errorInfo = result.userMessage {
                    continuation.resume(throwing: InvokeResultError(errorInfo: errorInfo))
                    return
                }

                if result.isSuccess {
                    continuation.resume(returning: EmptyResult())
                    return
                }
            }
        }
    }
    /// Deletes account.
    /// - parameters:
    ///     - accountId: account to be deleted.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    func delete(accountId: String, completion: @escaping CompletionCallback<EmptyResult>) -> RequestCancelable {
        baseApi.invokeMethod("account", method: .delete, parameters: ["accountId": accountId], completion: completion)
    }
}

// MARK: - Private functions
extension AccountApiImpl {
    /// Returns current account.
    /// - parameters:
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    private func account(completion: @escaping CompletionCallback<Account>) -> RequestCancelable {
        return baseApi.invokeMethod("account", parameter: nil, completion: completion)
    }

    /// Set current account.
    /// - parameters:
    ///     - account: account to be set.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    private func set(account: Account,
                     completion: @escaping CompletionCallback<Account>) -> RequestCancelable {
        return baseApi.invokeMethod("account",
                            method: .put,
                            body: account,
                            completion: completion)
    }

    /// Set current identifiers.
    /// - parameters:
    ///     - identifiers: identifiers to be set.
    ///     - completion: completion callback.
    /// - returns: cancelable object.
    @discardableResult
    private func set(identifiers: Identifiers,
                     completion: @escaping CompletionCallback<EmptyResult>) -> RequestCancelable {
        return baseApi.invokeMethod("account/set_identifiers",
                            method: .put,
                            body: identifiers,
                            completion: completion)
    }
}
