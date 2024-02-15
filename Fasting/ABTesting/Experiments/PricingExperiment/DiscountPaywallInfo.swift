//
//  DiscountPaywallInfo.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.02.2024.
//

import Dependencies
import AppStudioABTesting

struct DiscountPaywallInfo: Named, Equatable {

    var name: String
    let productId: String
    let paywallType: String
    let renewOfferTime: Int?
    let discount: Int
    let timerDurationInSeconds: Int
    let priceDisplay: String

    static var empty: DiscountPaywallInfo = {
        DiscountPaywallInfo(name: "empty",
                            productId: "",
                            paywallType: "",
                            renewOfferTime: nil,
                            discount: 0,
                            timerDurationInSeconds: 0,
                            priceDisplay: "")
    }()

    static var mock: DiscountPaywallInfo = {
        DiscountPaywallInfo(name: "mock",
                            productId: "com.municorn.Fasting.yearly_exp_1",
                            paywallType: "discount_timer",
                            renewOfferTime: 1000,
                            discount: 50,
                            timerDurationInSeconds: 1000,
                            priceDisplay: "old_new")
    }()
}

extension DiscountPaywallInfo: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: RawValue) {
        try? self.init(json: rawValue)
    }
    var rawValue: RawValue { name }
}

extension DiscountPaywallInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case productId = "product_id"
        case paywallType = "paywall_type"
        case renewOfferTime = "renew_offer_time"
        case discount
        case timerDurationInSeconds = "timer_duration_sec"
        case priceDisplay = "price_display"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        productId = try container.decode(String.self, forKey: .productId)
        paywallType = try container.decode(String.self, forKey: .paywallType)
        renewOfferTime = try container.decode(Int?.self, forKey: .renewOfferTime)
        discount = try container.decode(Int.self, forKey: .discount)
        timerDurationInSeconds = try container.decode(Int.self, forKey: .timerDurationInSeconds)
        priceDisplay = try container.decode(String.self, forKey: .priceDisplay)
    }
}
