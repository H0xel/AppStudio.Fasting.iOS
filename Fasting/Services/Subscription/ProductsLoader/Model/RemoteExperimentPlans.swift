//
//  RemoteExperimentPlans.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//

import Foundation

struct RemoteExperimentPlans: Codable {
    let productId: String
    let duration: String
    let introOffer: IntroOfferType?
    let introDuration: String?

    var isTrial: Bool {
        introOffer == .free
    }

    enum CodingKeys: String, CodingKey {
        case productId
        case duration
        case introOffer = "intro_offer"
        case introDuration = "intro_duration"
    }
}

enum IntroOfferType: String, Codable {
    case free
    case payAsYouGo = "pay_as_you_go"
    case payUpFront = "pay_up_front"
}
