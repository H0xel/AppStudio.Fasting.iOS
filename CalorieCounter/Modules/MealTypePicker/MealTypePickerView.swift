//
//  MealTypePickerView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import SwiftUI

struct MealTypePickerView: View {

    let currentMeal: MealType?
    let onPick: (MealType) -> Void

    var body: some View {
        HStack(spacing: .spacing) {
            VStack(spacing: .spacing) {
                mealTypeView(mealType: .breakfast)
                mealTypeView(mealType: .dinner)
            }
            VStack(spacing: .spacing) {
                mealTypeView(mealType: .lunch)
                mealTypeView(mealType: .snack)
            }
        }
        .padding(.horizontal, .horizonalPadding)
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
        .background(.white)
        .aligned(.bottom)
    }

    private func mealTypeView(mealType: MealType) -> some View {
        Button(action: {
            onPick(mealType)
        }, label: {
            VStack(spacing: .innnerSpacing) {
                mealType.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .imageWidth, height: .imageHeight)
                Text(mealType.title)
                    .font(.poppins(.body))
                    .foregroundStyle(.accent)
            }
            .aligned(.centerHorizontaly)
            .padding(.top, .innerTopPadding)
            .padding(.bottom, .innerBottomPadding)
            .background(Color.studioGreyFillCard)
            .continiousCornerRadius(.cornerRadius)
            .border(configuration: .init(
                cornerRadius: .cornerRadius,
                color: .accent,
                lineWidth: mealType == currentMeal ? 2 : 0)
            )
        })
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let innnerSpacing: CGFloat = 24
    static let innerTopPadding: CGFloat = 24
    static let innerBottomPadding: CGFloat = 20
    static let topPadding: CGFloat = 40
    static let bottomPadding: CGFloat = 48
    static let horizonalPadding: CGFloat = 32
    static let cornerRadius: CGFloat = 20
    static let imageWidth: CGFloat = 80
    static let imageHeight: CGFloat = 64
}

#Preview {
    ZStack {
        Color.red
        MealTypePickerView(currentMeal: .breakfast) { _ in }
    }
}
