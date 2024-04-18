//
//  TrueWeightCalculationServiceDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

extension DependencyValues {
    var trueWeightCalculationService: TrueWeightCalculationService {
        self[TrueWeightCalculationServiceKey.self]
    }
}

private enum TrueWeightCalculationServiceKey: DependencyKey {
    static let liveValue = TrueWeightCalculationServiceImpl()
}
