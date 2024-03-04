//
//  RemoteProducts.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.02.2024.
//

import Foundation

struct RemoteProducts: Codable {
    let subscriptionGroups: [String: [RemoteExperimentPlans]]

    enum CodingKeys: String, CodingKey {
        case subscriptionGroups = "subscription_groups"
    }
}
