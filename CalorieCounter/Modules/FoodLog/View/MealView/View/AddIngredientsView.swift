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
                    .font(.poppinsBold(.headerL))
                    .foregroundStyle(Color.accentColor)
                    .padding(.addButtonSmallPadding)
                    .background(Color.studioGrayFillProgress)
                    .continiousCornerRadius(.cornerRadius)
                    .padding(.vertical, .addButtonSmallPadding)

                Text(.addIngredientTitle)
                    .font(.poppins(.body))
            }
        }
    }
}

private extension LocalizedStringKey {
    static let addIngredientTitle: LocalizedStringKey = "FoodLogScreen.addIngredientButtonTitle"
}

private extension CGFloat {
    static let addButtonSpacing: CGFloat = 8
    static let addButtonSmallPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
}

#Preview {
    AddIngredientsView(onTap: {})
}
