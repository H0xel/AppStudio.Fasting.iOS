//
//  WeightGoalWidgetDatabaseInitializer.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation

import Foundation
import Dependencies
import MunicornCoreData

public class WeightGoalWidgetDatabaseInitializer {
    @Dependency(\.coreDataService) private var coreDataService

    public init() {}

    public func initialize() {
        let container = CloudCoreDataContainer(bundle: .module, modelName: "WeightGoalModel")
        coreDataService.initialize(with: container)
    }
}
