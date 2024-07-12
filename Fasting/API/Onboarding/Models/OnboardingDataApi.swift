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
                let weight = kgWeight == 0 ? 1 : kgWeight
                return .init(value: CGFloat(weight), units: .kg)
            }

            var lbsWeight: Double {
                let apiWeight = api.weight?.lbs ?? 0
                return apiWeight == 0 ? 1 : apiWeight
            }

            return .init(value: lbsWeight, units: .lb)
        }()

        let desiredWeightMeasure: WeightMeasure = {
            if let kgWeight = api.weightGoal?.kg {
                let weight = kgWeight == 0 ? 1 : kgWeight
                return .init(value: weight, units: .kg)
            }

            var lbsWeight: Double {
                let apiWeight = api.weightGoal?.lbs ?? 0
                return apiWeight == 0 ? 1 : apiWeight
            }

            return .init(value: lbsWeight, units: .lb)
        }()

        let heightMeasure: HeightMeasure = {
            if let cmHeight = api.height?.cm {
                let height  = cmHeight == 0 ? 1 : cmHeight
                return .init(value: CGFloat(height), units: .cm)
            }

            var ftHeight: Double {
                let apiHeight = api.height?.ft ?? 0
                return apiHeight == 0 ? 1 : apiHeight
            }

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
