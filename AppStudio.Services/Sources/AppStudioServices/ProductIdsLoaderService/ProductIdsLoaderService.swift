//  
//  ProductIdsLoaderService.swift
//  
//
//  Created by Amakhin Ivan on 29.04.2024.
//

public protocol ProductIdsLoaderService {
    func productsIds(ids: ProductIdsApp) -> [String]
    func defaultProductIds(app: ProductIdsApp) -> [String]
}
