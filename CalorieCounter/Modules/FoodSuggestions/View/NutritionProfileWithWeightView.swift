//
//  NutritionProfileWithWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.08.2024.
//

import SwiftUI

struct NutritionProfileWithWeightView: View {

    let profile: NutritionProfile
    let weight: String?
    let nutritionTypes: [NutritionType]

    var body: some View {
        HStack(spacing: .nutritionsSpacing) {
            ForEach(nutritionTypes, id: \.self) { type in
                NutritionView(amount: profile.amount(for: type),
                              configuration: .placeholderSmall(type: type),
                              bordered: false)
            }
            if let weight {
                Group {
                    Text("|")
                    Text(weight)
                        .lineLimit(1)
                }
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGrayPlaceholder)
            }
        }
    }
}

private extension CGFloat {
    static let nutritionsSpacing: CGFloat = 12
}

#Preview {
    NutritionProfileWithWeightView(profile: .mock, weight: "100 g", nutritionTypes: NutritionType.allCases)
}
