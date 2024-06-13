//
//  MealTypeView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import SwiftUI

struct MealTypeView: View {

    let record: MealTypeRecord
    let hasSubscription: Bool
    let onAddMealTap: (MealTypeRecord) -> Void
    let onCardType: (MealTypeRecord) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: hasMeal ? .top : .center) {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(record.type.title)
                        .font(.poppins(.headerS))
                        .padding(.top, .verticalPadding)
                        .padding(.bottom, hasMeal ? 0 : .verticalPadding)
                    if hasMeal {
                        MealNutritionProfileView(profile: record.nutritionProfile,
                                                 canShowNutritions: hasSubscription,
                                                 weight: nil)
                            .padding(.top, .nutritionTopPadding)
                            .padding(.bottom, .nutritionBottomPadding)
                            .animation(nil, value: record.calories)
                    }
                }
                Spacer()
                AddMealButton {
                    onAddMealTap(record)
                }
                .padding(.top, .verticalPadding)
                .padding(.bottom, hasMeal ? 0 : .verticalPadding)
            }
            .foregroundStyle(.accent)

            ForEach(record.meals) { meal in
                MealRecordView(meal: meal)
                    .padding(.bottom, meal == record.meals.last ?
                        .mealRecordBottomPadding * 2 :
                            .mealRecordBottomPadding)
            }
        }
        .padding(.horizontal, .horizontalPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
        .onTapGesture {
            onCardType(record)
        }
    }

    private var hasMeal: Bool {
        !record.meals.isEmpty
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
    static let nutritionTopPadding: CGFloat = 10
    static let nutritionBottomPadding: CGFloat = 24
    static let mealRecordBottomPadding: CGFloat = 16
}

private extension LocalizedStringKey {
    static let add: LocalizedStringKey = "MealTypeView.add"
}

#Preview {
    ZStack {
        Color.green
        MealTypeView(record: .init(type: .breakfast,
                                   meals: [Meal.mock]),
                     hasSubscription: false) { _ in } onCardType: { _ in }
            .padding(16)
    }
}
