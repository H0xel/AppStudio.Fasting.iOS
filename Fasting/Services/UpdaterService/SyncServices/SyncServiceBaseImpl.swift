//
//  SyncServiceBaseImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

import Foundation
import AppStudioFoundation
import Dependencies

class SyncServiceBaseImpl<T: Codable>: ServiceBaseImpl {
    @Dependency(\.storageService) var storageService

    var lastUpdateDate = Date.utcNow.add(days: -1)
    var updateTimeInterval = 10 * TimeInterval.minute
    var retryErrorInterval = 10 * TimeInterval.second
    @Atomic var isUpdating = false

    var shouldUpdate: Bool {
        lastUpdateDate.addingTimeInterval(updateTimeInterval) < Date.utcNow
    }

    func sync(isForce: Bool) async throws -> T? {
        guard !isUpdating && (isForce || shouldUpdate) else {
            return nil
        }
        isUpdating = true

        let result = try await syncRequest()
        lastUpdateDate = Date.utcNow
        isUpdating = false
        return result
    }

    func retry() async throws -> T? {
        try await Task.sleep(seconds: 1)
        return try await syncRequest()
    }

    func syncRequest() async throws -> T? {
        fatalError("need to override this function!")
    }
}
