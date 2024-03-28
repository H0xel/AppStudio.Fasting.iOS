//
//  WeightWidgetDatabaseInitializer.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies
import MunicornCoreData

public class WeightWidgetDatabaseInitializer {
    @Dependency(\.coreDataService) private var coreDataService

    public init() {}

    public func initialize() {
        let container = CloudCoreDataContainer(bundle: .module, modelName: "WeightWidgetModel")
        coreDataService.initialize(with: container)
    }
}
