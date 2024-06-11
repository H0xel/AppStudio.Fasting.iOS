//
//  QuickAddNutritionsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 04.06.2024.
//

import SwiftUI

struct QuickAddNutritionsView: View {

    @Binding var fats: Double
    @Binding var carbs: Double
    @Binding var proteins: Double

    var body: some View {
        HStack(spacing: .horizontalSpacing) {
            DoubleCustomTextField(
                title: .fatTitle,
                placeholder: "0",
                value: $fats,
                settings: .init(titleColor: NutritionType.fats.color,
                                units: .nutritionsUnits)
            )
            DoubleCustomTextField(
                title: .carbsTitle,
                placeholder: "0",
                value: $carbs,
                settings: .init(titleColor: NutritionType.carbs.color,
                                units: .nutritionsUnits)
            )
            DoubleCustomTextField(
                title: .proteinTitle,
                placeholder: "0",
                value: $proteins,
                settings: .init(titleColor: NutritionType.proteins.color,
                                units: .nutritionsUnits)
            )
        }
    }
}

private extension CGFloat {
    static let horizontalSpacing: CGFloat = 4
}

private extension String {
    static let fatTitle = NSLocalizedString("QuickAdd.fat", comment: "fat")
    static let carbsTitle = NSLocalizedString("QuickAdd.carbs", comment: "carbs")
    static let proteinTitle = NSLocalizedString("QuickAdd.protein", comment: "protein")
    static let nutritionsUnits = NSLocalizedString("QuickAdd.nutritions.units", comment: "g")
}

#Preview {
    QuickAddNutritionsView(fats: .constant(20), carbs: .constant(30), proteins: .constant(10))
}
