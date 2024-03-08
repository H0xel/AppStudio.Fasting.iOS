//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var storageService: StorageService {
        self[StorageServiceKey.self]
    }
}

enum StorageServiceKey: DependencyKey {
    static let liveValue: StorageService = DependencyContainer.container.storageService
}
