//
//  MealItemEditableValue.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.06.2024.
//

import Foundation
import AppStudioStyles

struct MealItemEditableValue {
    let value: Double
    let serving: MealServing
    let servings: [MealServing]

    var title: String? {
        if let gramms = serving.gramms(value: value) {
            return "\(gramms.withoutDecimalsIfNeeded) \(MealServing.gramms.units(for: value))"
        }
        return nil
    }

    var servingTitle: String {
        "\(value.withoutDecimalsIfNeeded) \(serving.units(for: value))"
    }
}
