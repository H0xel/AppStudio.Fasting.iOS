//
//  AddIngredientsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

struct AddIngredientsView: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: .addButtonSpacing) {
                Image.plus
                    .resizable()
                    .frame(width: .addButtonSmallPadding,
                           height: .addButtonSmallPadding)
                    .continiousCornerRadius(.cornerRadius)

                Text(.addIngredientTitle)
                    .font(.poppinsMedium(.description))
            }
            .padding(.vertical, .verticalPadding)
            .foregroundStyle(Color.studioBlackLight)
        }
    }
}

private extension LocalizedStringKey {
    static let addIngredientTitle: LocalizedStringKey = "FoodLogScreen.addIngredientButtonTitle"
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 6
    static let addButtonSpacing: CGFloat = 8
    static let addButtonSmallPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
}

#Preview {
    AddIngredientsView(onTap: {})
}
