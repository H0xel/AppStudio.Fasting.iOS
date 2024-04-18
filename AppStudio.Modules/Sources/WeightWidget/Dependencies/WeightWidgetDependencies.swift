//
//  WeightWidgetDependencies.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies
import MunicornCoreData
import MunicornFoundation

extension DependencyValues {
    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
}
