//
//  NutritionProfile.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct NutritionProfile: Codable, Hashable {
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
}

infix operator ++
infix operator **

extension NutritionProfile {

    var isEmpty: Bool {
        proteins == 0 && fats == 0 && carbohydrates == 0
    }

    var hasOnlyCalories: Bool {
        calories > 0 && proteins == 0 && fats == 0 && carbohydrates == 0
    }

    func amount(for type: NutritionType) -> Double {
        switch type {
        case .proteins: proteins
        case .fats: fats
        case .carbs: carbohydrates
        case .calories: calories
        }
    }

    func normalize(with weight: Double) -> NutritionProfile {
        NutritionProfile(calories: weight == 0 ? 0 : calories * 100 / weight,
                         proteins: weight == 0 ? 0 : proteins * 100 / weight,
                         fats: weight == 0 ? 0 : fats * 100 / weight,
                         carbohydrates: weight == 0 ? 0 : carbohydrates * 100 / weight)
    }

    func normalize(with servingSize: Double, amountPer: Double) -> NutritionProfile {
        NutritionProfile(calories: amountPer == 0 ? 0 : calories * (servingSize / amountPer),
                         proteins: amountPer == 0 ? 0 : proteins * (servingSize / amountPer),
                         fats: amountPer == 0 ? 0 : fats * (servingSize / amountPer),
                         carbohydrates: amountPer == 0 ? 0 : carbohydrates * (servingSize / amountPer))
    }

    func calculate(for weight: Double) -> NutritionProfile {
        NutritionProfile(calories: calories * weight / 100,
                         proteins: proteins * weight / 100,
                         fats: fats * weight / 100,
                         carbohydrates: carbohydrates * weight / 100)
    }

    func calculate(servingMultiplier: Double) -> NutritionProfile {
        self ** servingMultiplier
    }

    static func ++ (lhs: NutritionProfile, rhs: NutritionProfile) -> NutritionProfile {
        NutritionProfile(calories: lhs.calories + rhs.calories,
                         proteins: lhs.proteins + rhs.proteins,
                         fats: lhs.fats + rhs.fats,
                         carbohydrates: lhs.carbohydrates + rhs.carbohydrates)
    }

    static func ** (lhs: NutritionProfile, multiplyValue: Double) -> NutritionProfile {
        NutritionProfile(calories: lhs.calories * multiplyValue,
                         proteins: lhs.proteins * multiplyValue,
                         fats: lhs.fats * multiplyValue,
                         carbohydrates: lhs.carbohydrates * multiplyValue)
    }


    static var empty: NutritionProfile {
        .init(calories: 0, proteins: 0, fats: 0, carbohydrates: 0)
    }

    static let mock = NutritionProfile(calories: 1756, proteins: 84, fats: 120, carbohydrates: 90)
}

extension Array where Element == NutritionProfile {
    var total: NutritionProfile {
        self.reduce(NutritionProfile.empty) { $0 ++ $1 }
    }
}
