//
//  DatabaseInitializer.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 04.09.2024.
//

import UIKit
import MunicornCoreData
import Dependencies

class DatabaseInitializer: AppInitializer {

    @Dependency(\.coreDataService) private var coreDataService

    func initialize() {
        let container = CloudCoreDataContainer(bundle: .main, modelName: "Model")
        coreDataService.initialize(with: container)
        syncSchemeToCloud()
    }

    private func syncSchemeToCloud() {
#if DEBUG
        if !UIDevice.current.isSimulator {
            (coreDataService as? CloudCoreDataService)?.tryToSyncCoreDataModelChangesWithCloudKit()
        }
#endif
    }
}
