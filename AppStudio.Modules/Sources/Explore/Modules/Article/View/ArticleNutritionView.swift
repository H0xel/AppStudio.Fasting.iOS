//
//  ArticleNutritionView.swift
//  
//
//  Created by Amakhin Ivan on 22.04.2024.
//

import SwiftUI
import MunicornFoundation
import AppStudioStyles

struct ArticleNutritionView: View {
    let profile: ArticleNutritionProfile

    var body: some View {
        VStack(spacing: .zero) {
            
            HStack(alignment: .lastTextBaseline, spacing: .zero) {
                Text("\(Int(profile.calories)) \("Nutrition.kcal".localized(bundle: .module))")
                    .font(.poppins(.headerS))
                Spacer()
                Text("Nutrition.perServing".localized(bundle: .module))
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGrayText)
            }
            
            HStack(spacing: .zero) {
                Color.studioOrange
                    .frame(width: calculateWidth(param: profile.proteins), height: .chartHeight)
                    .corners([.topLeft, .bottomLeft], with: .cornerRadius)
                Color.studioGreen
                    .frame(width: calculateWidth(param: profile.fats), height: .chartHeight)
                Color.studioBlue
                    .frame(width: calculateWidth(param: profile.carbs), height: .chartHeight)
                    .corners([.bottomRight, .topRight], with: .cornerRadius)
            }
            .padding(.vertical, .chartVerticalPadding)
            
            HStack(spacing: .zero) {
                ArticleNutritionDescriptionView(amount: Int(profile.proteins), type: .protein)
                Spacer()
                ArticleNutritionDescriptionView(amount: Int(profile.fats), type: .fat)
                Spacer()
                ArticleNutritionDescriptionView(amount: Int(profile.carbs), type: .carbs)
            }
            .padding(.leading, .descriptionLeadingPadding)
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension ArticleNutritionView {
    func calculateWidth(param: CGFloat) -> CGFloat {
        let amount = profile.proteins + profile.fats + profile.carbs
        guard amount != 0 else { return 0 }
        let parameter = param / amount
        let horizontalPadding: CGFloat = 40
        return (UIScreen.main.bounds.width - horizontalPadding) * parameter
    }
}

private extension CGFloat {
    static let chartHeight: CGFloat = 12
    static var cornerRadius: CGFloat = 16
    static var chartVerticalPadding: CGFloat = 12
    static var horizontalPadding: CGFloat = 20
    static var descriptionLeadingPadding: CGFloat = 4
}

#Preview {
    ArticleNutritionView(profile: .mock)
}
