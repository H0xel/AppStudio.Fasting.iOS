//  
//  FreeUsageDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import Dependencies

extension DependencyValues {
    var freeUsageService: FreeUsageService {
        self[FreeUsageServiceKey.self]
    }
}

private enum FreeUsageServiceKey: DependencyKey {
    static var liveValue: FreeUsageService = FreeUsageServiceImpl()
    static var previewValue: FreeUsageService = FreeUsageServicePreview()
}
