//
//  AddMealButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import SwiftUI
import AppStudioStyles

struct AddMealButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(.add)
                .font(.poppins(.description))
                .padding(.top, .topPadding)
                .padding(.bottom, .bottomPadding)
                .padding(.horizontal, .horizontalPadding)
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.cornerRadius)
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let topPadding: CGFloat = 13
    static let bottomPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 44
}

private extension LocalizedStringKey {
    static let add: LocalizedStringKey = "MealTypeView.add"
}

#Preview {
    AddMealButton {}
}
