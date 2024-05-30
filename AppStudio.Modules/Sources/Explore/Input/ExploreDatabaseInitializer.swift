//
//  ExploreDatabaseInitializer.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Foundation
import Dependencies
import MunicornCoreData

public class ExploreDatabaseInitializer {

    @Dependency(\.coreDataService) private var coreDataService

    public init() {}

    public func initialize() {
        let container = CloudCoreDataContainer(bundle: .module, modelName: "ExploreModel")
        coreDataService.initialize(with: container)
    }
}
