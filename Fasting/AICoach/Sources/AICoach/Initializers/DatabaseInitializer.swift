//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import Dependencies
import MunicornCoreData
import CoreData

public class AICoachDatabaseInitializer {

    @Dependency(\.coreDataService) private var coreDataService

    public init() {}

    public func initialize() {
        let container = CloudCoreDataContainer(bundle: .coachBundle, modelName: "AICoachModel")
        coreDataService.initialize(with: container)
    }
}
