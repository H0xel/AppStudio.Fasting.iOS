//  
//  ProductsLoaderDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//

import Dependencies

extension DependencyValues {
    var productsLoaderService: ProductsLoaderService {
        self[ProductsLoaderServiceKey.self]
    }
}

private enum ProductsLoaderServiceKey: DependencyKey {
    static var liveValue: ProductsLoaderService = ProductsLoaderServiceImpl()
    static var testValue: ProductsLoaderService = ProductsLoaderServiceImpl()
    static var previewValue: ProductsLoaderService = ProductsLoaderServiceImpl()
}
