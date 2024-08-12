//
//  CustomFoodAmountView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI

struct CustomFoodAmountView: View {
    let configuration: Configuration
    @Binding var selectedField: CustomFoodField
    @Binding var weight: Double
    let selectedServing: MealServing
    let fieldType: CustomFoodField
    let isInitialWeight: Bool

    init(configuration: Configuration,
         selectedField: Binding<CustomFoodField>,
         weight: Binding<Double>,
         selectedServing: MealServing = .gramms,
         fieldType: CustomFoodField,
         isInitialWeight: Bool) {
        self.configuration = configuration
        self._selectedField = selectedField
        self._weight = weight
        self.selectedServing = selectedServing
        self.fieldType = fieldType
        self.isInitialWeight = isInitialWeight
    }

    var body: some View {
        HStack {
            Text(configuration.title)
                .font(configuration.font)
            Spacer()
            Button(action: { selectedField = fieldType }, label: {
                MealWeightView(type: .weight(weight),
                               serving: selectedServing,
                               isTapped: selectedField == fieldType,
                               withoutDecimalIfNeeded: true,
                               weightColor: isInitialWeight ? Color.studioGreyText : Color.studioBlackLight)
            })
        }
        .padding(.vertical, .verticalPadding)
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
    }
}

extension CustomFoodAmountView {
    struct Configuration {
        let title: LocalizedStringKey
        let font: Font
    }
}

extension CustomFoodAmountView.Configuration {
    static var amount: CustomFoodAmountView.Configuration {
        .init(title: "CustomFood.textfield.amountPer", font: .poppinsMedium(.body))
    }

    static var calories: CustomFoodAmountView.Configuration {
        .init(title: "CustomFood.textfield.calories", font: .poppins(.description))
    }

    static var fat: CustomFoodAmountView.Configuration {
        .init(title: "CustomFood.textfield.fat", font: .poppins(.description))
    }

    static var protein: CustomFoodAmountView.Configuration {
        .init(title: "CustomFood.textfield.protein", font: .poppins(.description))
    }

    static var carbs: CustomFoodAmountView.Configuration {
        .init(title: "CustomFood.textfield.carbs", font: .poppins(.description))
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 8
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
}

#Preview {
    CustomFoodAmountView(
        configuration: .amount,
        selectedField: .constant(.servingName), weight: .constant(0),
        fieldType: .amountPer,
        isInitialWeight: false
    )
}
