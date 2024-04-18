//  
//  WaterIntakeDependencies.swift
//  
//
//  Created by Denis Khlopin on 26.03.2024.
//

import Dependencies

extension DependencyValues {
    var waterIntakeService: WaterIntakeService {
        self[WaterIntakeServiceKey.self]!
    }
}

public enum WaterIntakeServiceKey: DependencyKey {
    public static var liveValue: WaterIntakeService?
}

extension WaterIntakeServiceKey {
    public static var previewValue: WaterIntakeService? = WaterIntakeServiceMock()
    public static var testValue: WaterIntakeService? = WaterIntakeServiceMock()
}
