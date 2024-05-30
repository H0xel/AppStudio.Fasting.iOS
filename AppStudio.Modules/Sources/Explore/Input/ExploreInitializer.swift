//
//  File.swift
//  
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Foundation
import AppStudioAnalytics
import MunicornFoundation
import Dependencies

public class ExploreInitializer {
    @Dependency(\.exploreService) private var exploreService
    @Dependency(\.imageDocumentService) private var imageDocumentService
    public init() {}

    public func initialize(exploreApi: ExploreApi, iCloudContainerIdentifier: String) {
        ExploreApiKey.liveValue = exploreApi
        initializeImageDocumentService(iCloudContainerIdentifier: iCloudContainerIdentifier)

        Task {
            let articles = try await exploreService.loadArticles()
        }
    }

    private func initializeImageDocumentService(iCloudContainerIdentifier: String) {
        ImageDataServiceKey.liveValue = imageDocumentService
        Task {
            let container = CloudDocumentStorageContainer(identifier: iCloudContainerIdentifier)
            await imageDocumentService.initialize(container: container)
        }
    }
}
