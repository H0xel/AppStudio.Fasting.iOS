//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import Dependencies
import MunicornCoreData
import CoreData

public class WaterCounterDatabaseInitializer {

    @Dependency(\.coreDataService) private var coreDataService

    public init() {}

    public func initialize() {
        let container = CloudCoreDataContainer(bundle: .module, modelName: "WaterCounterModel")
        coreDataService.initialize(with: container)
    }
}
