//
//  FoodLogTextFieldButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI

struct FoodLogTextFieldButton: View {
    var isAccent = false
    let image: Image
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            image
                .resizable()
                .renderingMode(.template)
                .frame(width: .imageWidth, height: .imageWidth)
                .foregroundStyle(isAccent ? .white : .studioBlackLight)
                .font(.footnote.weight(.medium))
                .frame(width: .backgroundWidth, height: .backgroundWidth)
                .background(isAccent ? Color.studioBlackLight : Color.studioGreyFillProgress)
                .continiousCornerRadius(.backgroundWidth / 2)
        }
    }
}

private extension CGFloat {
    static let backgroundWidth: CGFloat = 48
    static let imageWidth: CGFloat = 24
}

#Preview {
    HStack {
        FoodLogTextFieldButton(image: .checkmark, onTap: {})
        FoodLogTextFieldButton(isAccent: true, image: .arrowUp, onTap: {})
    }
}
