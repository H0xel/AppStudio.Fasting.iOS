//
//  File.swift
//  
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Foundation
import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {

    var exploreApi: ExploreApi {
        self[ExploreApiKey.self]!
    }

    var articleImageService: ImageDocumentService {
        self[ImageDataServiceKey.self]!
    }

    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }
}

enum ExploreApiKey: DependencyKey {
    static var liveValue: ExploreApi?
}

enum ImageDataServiceKey: DependencyKey {
    static var liveValue: ImageDocumentService?
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
}
