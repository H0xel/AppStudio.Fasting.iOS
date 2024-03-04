//
//  NutritionType.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI

enum NutritionType: String, CaseIterable {
    case calories
    case proteins
    case fats
    case carbs

    var title: String {
        NSLocalizedString("NutritionProfile.\(rawValue)", comment: "")
    }

    var firstLetter: String {
        title.prefix(1).uppercased()
    }

    var color: Color {
        switch self {
        case .proteins: .studioOrange
        case .fats: .studioGreen
        case .carbs: .studioBlue
        case .calories: .studioRed
        }
    }

    var image: Image? {
        switch self {
        case .proteins, .carbs, .fats: nil
        case .calories: .flame
        }
    }
}
