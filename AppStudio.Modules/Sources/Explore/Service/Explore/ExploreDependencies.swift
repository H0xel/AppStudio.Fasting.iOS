//  
//  ExploreDependencies.swift
//  
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Dependencies

extension DependencyValues {
    var exploreService: ExploreService {
        self[ExploreServiceKey.self]
    }
}

private enum ExploreServiceKey: DependencyKey {
    static var liveValue: ExploreService = ExploreServiceImpl()
}
