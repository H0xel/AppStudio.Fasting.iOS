//  
//  ProductsLoaderServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//
import AppStudioABTesting
import Dependencies

class ProductsLoaderServiceImpl: ProductsLoaderService {
    @Dependency(\.appCustomization) var appCustomization

    func load() async throws -> AvailableProducts {
        for try await value in appCustomization.allProductsObservable.values.prefix(1) {
            return value
        }
        return .empty
    }
}
