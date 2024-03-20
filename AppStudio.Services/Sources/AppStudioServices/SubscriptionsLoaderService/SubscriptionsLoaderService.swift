//  
//  SubscriptionsLoaderService.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import StoreKit

public protocol SubscriptionsLoaderService {
    var subscriptions: [SKProduct] { get }
    func initialize()
}
