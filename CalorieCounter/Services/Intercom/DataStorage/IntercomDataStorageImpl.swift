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
    @Dependency(\.accountProvider) private var accountProvider
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
