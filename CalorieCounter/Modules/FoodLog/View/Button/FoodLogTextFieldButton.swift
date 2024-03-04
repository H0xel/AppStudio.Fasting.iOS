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
                .renderingMode(.template)
                .foregroundStyle(isAccent ? .white : .accent)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(width: .imageWidth, height: .imageWidth)
                .background(isAccent ? Color.accentColor : Color.studioGreyFillProgress)
                .continiousCornerRadius(.imageWidth / 2)
        }
    }
}

private extension CGFloat {
    static let imageWidth: CGFloat = 40
}

#Preview {
    HStack {
        FoodLogTextFieldButton(image: .checkmark, onTap: {})
        FoodLogTextFieldButton(isAccent: true, image: .arrowUp, onTap: {})
    }
}
