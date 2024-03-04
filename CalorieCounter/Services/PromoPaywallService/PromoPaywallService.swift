//  
//  PromoPaywallService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 13.02.2024.
//

import RxSwift
import StoreKit

protocol PromoPaywallService {
    var promoSubscription: Observable<PromotionalOffer?> { get }
}
