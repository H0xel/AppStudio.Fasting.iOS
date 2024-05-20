//  
//  ProductIdsServiceImpl.swift
//  
//
//  Created by Amakhin Ivan on 29.04.2024.
//

import AppStudioABTesting

class ProductIdsLoaderServiceImpl: BaseAppCustomization, ProductIdsLoaderService {
    private let allProductKey = "all_products_2"

    func productsIds(ids: ProductIdsApp) -> [String] {
        do {
            let allRemoteProducts = value(forKey: allProductKey) ?? ""
            let productIds = try AvailableProducts(json: allRemoteProducts).products
            return productIds
        } catch {
            return ids.localIds
        }
    }
}

struct AvailableProducts: Codable {
    let products: [String]
}
