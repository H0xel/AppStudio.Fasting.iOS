//
//  OnboardingDataApi.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.05.2024.
//

import Foundation
import AppStudioModels

struct OnboardingDataApi: Codable {
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let sex: String?
    let age: String?
    let focus: String?
    let targetZones: [String]?
    let height: HeightApi?
    let weight: WeightApi?
    let weightGoal: WeightApi?
    let oldRoutine: Int?
    let specificMotivation: String?
    let specificMotivationDate: String?
    let exploreWhat: [String]?
    let quicklyLoseWeight: String?
    let email: String?
}

extension OnboardingData {
    init(_ api: OnboardingDataApi) {

        let sex: Sex = {
            if api.sex == "woman" {
                return .female
            }

            if api.sex == "men" {
                return .male
            }

            return .other
        }()

        let weightMeasure: WeightMeasure = {
            if let kgWeight = api.weight?.kg {
                return .init(value: CGFloat(kgWeight), units: .kg)
            }

            let lbsWeight = api.weight?.lbs ?? 0

            return .init(value: lbsWeight, units: .lb)
        }()

        let desiredWeightMeasure: WeightMeasure = {
            if let kgWeight = api.weightGoal?.kg {
                return .init(value: kgWeight, units: .kg)
            }

            let lbsWeight = api.weightGoal?.lbs ?? 0

            return .init(value: lbsWeight, units: .lb)
        }()

        let heightMeasure: HeightMeasure = {
            if let cmHeight = api.height?.cm {
                return .init(value: CGFloat(cmHeight), units: .cm)
            }

            let ftHeight = api.height?.ft ?? 0
            let inchHeight = api.height?.inch ?? 0

            return .init(feet: ftHeight, inches: inchHeight)
        }()

        self = .init(
            goals: .init([]),
            sex: sex,
            birthdayDate: nil,
            height: heightMeasure,
            weight: weightMeasure,
            desiredWeight: desiredWeightMeasure,
            activityLevel: .sedentary,
            specialEvent: .noSpecialEvent,
            specialEventDate: nil
        )
    }
}
