//
//  DatabaseInitializer.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import MunicornCoreData
import Dependencies
import UIKit

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
