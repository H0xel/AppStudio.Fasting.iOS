//  
//  WaterDependencies.swift
//  
//
//  Created by Denis Khlopin on 15.03.2024.
//

import Dependencies

public extension DependencyValues {
    var waterService: WaterService {
        self[WaterServiceKey.self]
    }
}

private enum WaterServiceKey: DependencyKey {
    static var liveValue: WaterService = WaterServiceImpl()
    static var previewValue: WaterService = WaterServiceMock()
    static var testValue: WaterService = WaterServiceImpl()
}
