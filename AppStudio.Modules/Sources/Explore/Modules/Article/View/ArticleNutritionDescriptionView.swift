//
//  ArticleNutritionDescriptionView.swift
//  
//
//  Created by Amakhin Ivan on 22.04.2024.
//

import SwiftUI
import AppStudioStyles

struct ArticleNutritionDescriptionView: View {
    let amount: Int
    let type: NutritionType
    
    var body: some View {
        HStack(spacing: .spacing) {
            Circle()
                .foregroundStyle(type.color)
                .frame(height: 8)
            Text(type.title)
            Text("\(amount) \("Nutrition.g".localized(bundle: .module))")
        }
        .font(.poppins(.description))
    }
}

private extension CGFloat {
    static var spacing: CGFloat = 4
}

extension ArticleNutritionDescriptionView {
    enum NutritionType: String {
        case protein
        case fat
        case carbs
        
        var title: String {
            "Nutrition.\(rawValue)".localized(bundle: .module)
        }
        
        var color: Color {
            switch self {
            case .protein:
                Color.studioOrange
            case .fat:
                Color.studioGreen
            case .carbs:
                Color.studioBlue
            }
        }
    }
}

#Preview {
    ArticleNutritionDescriptionView(amount: 36, type: .protein)
}
