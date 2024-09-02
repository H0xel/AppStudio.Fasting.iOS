//  
//  W2WLoadingDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 28.08.2024.
//

import Dependencies

extension DependencyValues {
    var w2WLoadingService: W2WLoadingService {
        self[W2WLoadingServiceKey.self]
    }
}

private enum W2WLoadingServiceKey: DependencyKey {
    static var liveValue: W2WLoadingService = W2WLoadingServiceImpl()
    static var testValue: W2WLoadingService = W2WLoadingServiceImpl()
    static var previewValue: W2WLoadingService = W2WLoadingServiceImpl()
}
