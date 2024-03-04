//
//  GetPlusButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import SwiftUI

struct GetPlusButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: .spacing) {
                Image.crownFill
                Text(.title)
                    .font(.poppins(.buttonText))
            }
            .foregroundStyle(.white)
            .frame(height: .height)
            .aligned(.centerHorizontaly)
            .background(
                LinearGradient(
                    colors: [
                        .studioOrange,
                        .studioRed,
                        .studioPurple,
                        .studioBlue,
                        .studioSky
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .continiousCornerRadius(.cornerRadius)
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
    static let height: CGFloat = 56
    static let cornerRadius: CGFloat = 20
}

private extension LocalizedStringKey {
    static let title: LocalizedStringKey = "FoodScreen.getPlus"
}

#Preview {
    GetPlusButton {}
}
