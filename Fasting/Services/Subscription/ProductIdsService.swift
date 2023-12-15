//
//  ProductIdsService.swift
//  AppStudio
//
//  Created by Denis Khlopin on 09.08.2023.
//

import RxSwift

public protocol ProductIdsService {
    var productIds: Observable<[String]> { get }
    var paywallProductIds: Observable<[String]> { get }
    var onboardingPaywallProductIds: Observable<[String]> { get }
}
