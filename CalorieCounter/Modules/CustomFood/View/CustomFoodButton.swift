//
//  CustomFoodButton.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI

struct CustomFoodButton: View {
    let isDisabled: Bool
    var onSaveTapped: () -> Void

    var body: some View {
        Button {
            onSaveTapped()
        } label: {
            Text("SaveTitle")
                .font(.poppins(.body))
                .disabled(isDisabled)
                .padding(.vertical, .verticalPadding)
                .aligned(.centerHorizontaly)
                .foregroundStyle(Color.white)
                .background(isDisabled ? Color.studioGreyStrokeFill : Color.studioBlackLight)
                .continiousCornerRadius(.cornerRadius)
        }
        .padding(.top, .topPadding)
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 15
    static let cornerRadius: CGFloat = 20
    static let topPadding: CGFloat = 24
}

#Preview {
    CustomFoodButton(isDisabled: true) {}
}
