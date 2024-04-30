//  
//  DeepLinkDependencies.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Dependencies

public extension DependencyValues {
    var deepLinkService: DeepLinkService {
        self[DeepLinkServiceKey.self]
    }
}

private enum DeepLinkServiceKey: DependencyKey {
    static var liveValue: DeepLinkService = DeepLinkServiceImpl()
    static var testValue: DeepLinkService = DeepLinkServiceImpl()
    static var previewValue: DeepLinkService = DeepLinkServiceImpl()
}
