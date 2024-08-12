//
//  MealServing.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 13.06.2024.
//

import Foundation

struct MealServing: Codable, Hashable {
    let weight: Double?
    let measure: String
    let quantity: Double

    private let pluralMeasure: String?

    init(weight: Double?, measure: String, quantity: Double, pluralMeasure: String? = nil) {
        self.weight = weight
        self.measure = measure
        self.quantity = quantity
        if pluralMeasure == nil && measure == "serving" {
            self.pluralMeasure = "servings"
        } else {
            self.pluralMeasure = pluralMeasure
        }
    }
}

extension MealServing {
    func units(for value: Double) -> String {
        guard let pluralMeasure else {
            return measure
        }
        if value == 1.0 {
            return measure
        }
        return pluralMeasure
    }

    func gramms(value: Double) -> Double? {
        if let weight {
            return (value * weight) / quantity
        }
        return nil
    }

    func multiplier(for value: Double) -> Double {
        if let valueInGramms = gramms(value: value) {
            let multiplier = valueInGramms / 100
            return multiplier
        } else {
            return value / quantity
        }
    }

    func value(with multiplier: Double) -> Double {
        if let unitsPer100Gramm {
            return unitsPer100Gramm * multiplier
        }
        return multiplier * quantity
    }

    func convert(value: Double, to serving: MealServing) -> Double {
        let weightInGramms = (value / quantity) * (weight ?? 1)
        let result = (weightInGramms / (serving.weight ?? 1)) * serving.quantity
        return result
    }

    private var unitsPer100Gramm: Double? {
        if let weight {
            return 100 * quantity / weight
        }
        return nil
    }
}

// MARK: - static values
extension MealServing {
    static var gramms: MealServing {
        .init(weight: 100, measure: "g", quantity: 100)
    }

    static var ounces: MealServing {
        .init(weight:  28.3495, measure: "oz", quantity: 1.0)
    }

    static var pounds: MealServing {
        .init(weight: 453.592, measure: "lb", quantity: 1.0)
    }

    static var flOz: MealServing {
        .init(weight: 237, measure: "fl oz", quantity: 8)
    }

    static var defaultServing: MealServing {
        gramms
    }

    static var serving: MealServing {
        .init(weight: nil, measure: "serving", quantity: 1, pluralMeasure: "servings")
    }
}

extension Array where Element == MealServing {
    static var defaultServings: [MealServing] {
        [.gramms, .ounces, .pounds]
    }
}
