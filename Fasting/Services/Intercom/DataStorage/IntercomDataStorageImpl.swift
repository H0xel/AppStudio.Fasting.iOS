//
//  IntercomDataStorageImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

import Foundation
import Combine
import Dependencies

class IntercomDataStorageImpl: IntercomDataStorage {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.accountProvider) private var accountProvider
    @Dependency(\.obfuscator) private var obfuscator
    @Dependency(\.intercomUpdater) private var intercomUpdater
    private let obfuscatedAppId = GlobalConstants.intercomObfuscatedAppId
    private let obfuscatedApiKey = GlobalConstants.intercomObfuscatedApiKey


    private var intercomDataTrigger = CurrentValueSubject<IntercomData?, Never>(nil)

    var intercomData: AnyPublisher<IntercomData?, Never> {
        intercomDataTrigger
            .eraseToAnyPublisher()
    }

    func initialize() {
        let userId = accountProvider.accountId
        sync(userId: userId, hash: "")
    }

    func sync(userId: String?, hash: String?) {
        guard let userId, let hash else {
            intercomDataTrigger.send(nil)
            return
        }
        intercomDataTrigger.send(IntercomData(hash: hash, userId: userId))
    }
}
