//
//  DrinkingWaterObserver.swift
//
//
//  Created by Denis Khlopin on 15.03.2024.
//

import Foundation

import Foundation
import MunicornCoreData
import Dependencies

typealias DrinkingWaterObserver = CoreDataObserver<DrinkingWater>

extension DrinkingWaterObserver {
    convenience init() {
        @Dependency(\.coreDataService) var coreDataService
        self.init(coreDataService: coreDataService)
    }
}
