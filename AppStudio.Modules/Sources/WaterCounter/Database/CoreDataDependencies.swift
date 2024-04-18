//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
}
