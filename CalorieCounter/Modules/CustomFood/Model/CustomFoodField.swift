//
//  CustomFoodField.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 15.07.2024.
//

import Foundation
import WaterCounter

enum CustomFoodField: String, CaseIterable {
    case none

    case foodName
    case brandName

    case servingSize
    case servingAmount
    case servingName

    case amountPer
    case calories
    case fat
    case carbs
    case protein

    enum KeyboardType {
        case customNumpad
        case customText
        case text
        case none
    }

    func next() -> CustomFoodField {
        let allCases = CustomFoodField.allCases
        let currentIndex = allCases.firstIndex(of: self) ?? 0
        let nextIndex = allCases.index(after: currentIndex)
        return nextIndex == allCases.endIndex ? (allCases.first ?? .none) : allCases[nextIndex]
    }

    func previous() -> CustomFoodField {
        let allCases = CustomFoodField.allCases
        let currentIndex = allCases.firstIndex(of: self) ?? 0
        let previousIndex = allCases.index(before: currentIndex)
        return currentIndex == allCases.startIndex ? (allCases.last ?? .none) : allCases[previousIndex]
    }

    var canShowServings: Bool {
        self == .servingSize || self == .amountPer
    }

    var servings: [MealServing] {
        if self == .servingSize || self == .amountPer {
            return [
                .gramms,
                .init(weight: nil, measure: WaterUnits.liters.unitsTitle, quantity: 1)
            ]
        }
        return []
    }

    var keyboardTitle: String {
        if self == .servingName || self == .servingAmount {
            return "CustomFood.textfield.servingName".localized()
        }

        return "CustomFood.textfield.\(rawValue)".localized()
    }

    var keyboardType: KeyboardType {
        switch self {
        case .none: return .none
        case .brandName, .foodName: return .text
        case .servingName: return .customText
        default: return .customNumpad
        }
    }
}
