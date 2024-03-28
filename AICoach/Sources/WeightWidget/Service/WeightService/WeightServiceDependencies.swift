//
//  WeightServiceDependencies.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

public extension DependencyValues {
    var weightService: WeightService {
        self[WeightServiceKey.self]
    }
}

private enum WeightServiceKey: DependencyKey {
    static let liveValue = WeightServiceImpl()
}
