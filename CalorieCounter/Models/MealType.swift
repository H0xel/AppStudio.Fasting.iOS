//
//  MealType.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI

enum MealType: String, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack

    var title: String {
        NSLocalizedString("MealType.\(rawValue)", comment: "")
    }

    var image: Image {
        switch self {
        case .breakfast:
            return .init(.eggAndLeave)
        case .lunch:
            return .init(.lunch)
        case .dinner:
            return .init(.dinner)
        case .snack:
            return .init(.snack)
        }
    }
}
