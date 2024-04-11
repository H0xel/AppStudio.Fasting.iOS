//
//  DiscountPaywallInfo.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.02.2024.
//

import Dependencies
import AppStudioABTesting

public struct DiscountPaywallInfo: Named, Equatable {

    public var name: String
    public let productId: String?
    public let delayTimeInHours: Double?
    public let paywallType: String?
    public let renewOfferTime: Int?
    public let discount: Int?
    public let timerDurationInSeconds: Int?
    public let priceDisplay: String?

    public init(name: String, 
                productId: String?,
                delayTimeInHours: Double?,
                paywallType: String?,
                renewOfferTime: Int?,
                discount: Int?,
                timerDurationInSeconds: Int?,
                priceDisplay: String?
    ) {
        self.name = name
        self.productId = productId
        self.delayTimeInHours = delayTimeInHours
        self.paywallType = paywallType
        self.renewOfferTime = renewOfferTime
        self.discount = discount
        self.timerDurationInSeconds = timerDurationInSeconds
        self.priceDisplay = priceDisplay
    }

    public static var empty: DiscountPaywallInfo = {
        DiscountPaywallInfo(name: "empty",
                            productId: "",
                            delayTimeInHours: nil,
                            paywallType: nil,
                            renewOfferTime: nil,
                            discount: 0,
                            timerDurationInSeconds: 0,
                            priceDisplay: "")
    }()

    public static var mock: DiscountPaywallInfo = {
        DiscountPaywallInfo(name: "mock",
                            productId: "com.municorn.Fasting.yearly_exp_1",
                            delayTimeInHours: 0.5,
                            paywallType: "discount_timer",
                            renewOfferTime: 1,
                            discount: 50,
                            timerDurationInSeconds: 1000,
                            priceDisplay: "old_new")
    }()
}

extension DiscountPaywallInfo: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        try? self.init(json: rawValue)
    }
    public var rawValue: RawValue { name }
}

extension DiscountPaywallInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case productId = "product_id"
        case delayTimeInHours = "delay_time_h"
        case paywallType = "paywall_type"
        case renewOfferTime = "renew_offer_time"
        case discount
        case timerDurationInSeconds = "timer_duration_sec"
        case priceDisplay = "price_display"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        productId = try container.decode(String?.self, forKey: .productId)
        delayTimeInHours = try container.decode(Double?.self, forKey: .delayTimeInHours)
        paywallType = try container.decode(String?.self, forKey: .paywallType)
        renewOfferTime = try container.decode(Int?.self, forKey: .renewOfferTime)
        discount = try container.decode(Int?.self, forKey: .discount)
        timerDurationInSeconds = try container.decode(Int?.self, forKey: .timerDurationInSeconds)
        priceDisplay = try container.decode(String?.self, forKey: .priceDisplay)
    }
}
