//
//  ChangeWeightButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.05.2024.
//

import SwiftUI

struct ChangeWeightButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image.arrowUp
                .foregroundStyle(Color.white)
                .frame(width: .backgroundWidth, height: .backgroundWidth)
                .background(Color.studioBlackLight)
                .continiousCornerRadius(.backgroundWidth / 2)
        }
    }
}

private extension CGFloat {
    static let backgroundWidth: CGFloat = 40
    static let imageWidth: CGFloat = 24
}

#Preview {
    ChangeWeightButton(onTap: {})
}
