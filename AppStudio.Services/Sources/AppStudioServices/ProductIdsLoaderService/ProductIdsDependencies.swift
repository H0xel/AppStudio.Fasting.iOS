//  
//  ProductIdsDependencies.swift
//  
//
//  Created by Amakhin Ivan on 29.04.2024.
//

import Dependencies

public extension DependencyValues {
    var productIdsLoaderService: ProductIdsLoaderService {
        self[ProductIdsServiceKey.self]
    }
}

private enum ProductIdsServiceKey: DependencyKey {
    static var liveValue: ProductIdsLoaderService = ProductIdsLoaderServiceImpl()
    static var testValue: ProductIdsLoaderService = ProductIdsLoaderServiceImpl()
    static var previewValue: ProductIdsLoaderService = ProductIdsLoaderServiceImpl()
}
