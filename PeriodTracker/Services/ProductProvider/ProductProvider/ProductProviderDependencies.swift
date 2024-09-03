//
//  ProductProviderDependencies.swift
//  AppStudioTemplate
//
//  Created by Amakhin Ivan on 03.09.2024.
//

import Dependencies

extension DependencyValues {
    var productProvider: ProductProvider {
        self[ProductProviderKey.self]
    }
}

private enum ProductProviderKey: DependencyKey {
    static var liveValue: ProductProvider = ProductProviderImpl()
    static var testValue: ProductProvider = ProductProviderImpl()
    static var previewValue: ProductProvider = ProductProviderImpl()
}
