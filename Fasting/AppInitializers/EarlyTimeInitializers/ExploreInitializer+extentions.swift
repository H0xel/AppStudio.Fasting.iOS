//
//  ExploreInitializer+extentions.swift
//  Fasting
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Foundation
import Dependencies
import Explore

extension ExploreInitializer: AppInitializer {
    func initialize() {
        initialize(exploreApi: ExploreApiImpl(),
                   iCloudContainerIdentifier: "iCloud.com.municorn.Fasting")
    }
}

extension ExploreDatabaseInitializer: AppInitializer {}
