//  
//  ProductsLoaderService.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//


protocol ProductsLoaderService {
    func load() async throws -> AvailableProducts
}
