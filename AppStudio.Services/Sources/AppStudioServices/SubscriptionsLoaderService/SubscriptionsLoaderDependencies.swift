//  
//  SubscriptionsLoaderDependencies.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import Dependencies

public extension DependencyValues {
    var subscriptionsLoaderService: SubscriptionsLoaderService {
        self[SubscriptionsLoaderServiceKey.self]
    }
}

private enum SubscriptionsLoaderServiceKey: DependencyKey {
    static var liveValue: SubscriptionsLoaderService = SubscriptionsLoaderServiceImpl()
    static var testValue: SubscriptionsLoaderService = SubscriptionsLoaderServiceImpl()
    static var previewValue: SubscriptionsLoaderService = SubscriptionsLoaderServiceImpl()
}
