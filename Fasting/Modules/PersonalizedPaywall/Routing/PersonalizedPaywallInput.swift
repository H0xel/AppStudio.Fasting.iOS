//
//  PersonalizedPaywallInput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import SwiftUI

struct PersonalizedPaywallInput {
    let title: String
    let chart: PersonalizedChart.ViewData
    let sex: Sex
    let activityLevel: ActivityLevel
    let weightUnit: WeightUnit
    let bulletPoints: [String]
    let descriptionPoints: [PersonalizedDescriptionView.ViewData]
}

extension PersonalizedPaywallInput {
    static var mock: PersonalizedPaywallInput {
        let userWeight = "52 kg"
        let weightLossDate = "Feb 14"
        let title = String(format: NSLocalizedString("PersonalizedPaywall.headerTitle", comment: ""),
                           arguments: [userWeight, weightLossDate])

        let sex: Sex = .male
        let activityLevel: ActivityLevel = .sedentary

        return .init(title: title,
                     chart: .init(
                        startWeight: "56 kg",
                        endWeight: "52 kg",
                        weightDifference: "- 4 kg",
                        endDate: "Feb 14",
                        specialEventWithWeightTitle: "Birthday 53 kg",
                        specialEventDate: "Feb 13",
                        specialEventStatus: .isLaterThenEndDate),
                     sex: sex,
                     activityLevel: .sedentary,
                     weightUnit: .kg,
                     bulletPoints: [
                        String(
                            format: NSLocalizedString("PersonalizedPaywall.loseWeightBullet", comment: ""),
                            arguments: ["3", "birthday"]
                        ),
                        "Start seeing results in just 1 month",
                        "Build your dream body",
                        "Become more active in daily life"
                     ],
                     descriptionPoints: [
                        .init(type: .text("32+"),
                              description: String(
                                format: NSLocalizedString("PersonalizedPaywall.description.1", comment: ""),
                                arguments: [sex.paywallTitle, "32"]
                              )),
                        .init(type: .image(.figureWalk),
                              description: String(
                                format: NSLocalizedString("PersonalizedPaywall.description.2", comment: ""),
                                activityLevel.rawValue.lowercased()
                              ))
                     ]
        )
    }
}
