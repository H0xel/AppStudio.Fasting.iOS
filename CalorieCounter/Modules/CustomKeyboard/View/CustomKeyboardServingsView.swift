//
//  CustomKeyboardServingsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.06.2024.
//

import SwiftUI
import AudioToolbox

struct CustomKeyboardServingsView: View {

    let currentServing: MealServing
    let servings: [MealServing]
    let onChange: (MealServing) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .spacing) {
                Spacer(minLength: .spacerLength)
                ForEach(servings, id: \.self) { serving in
                    Button {
                        AudioServicesPlaySystemSound(1156)
                        onChange(serving)
                    } label: {
                        Text(serving.measure)
                            .font(serving == currentServing ? .poppinsBold(.description) : .poppins(.description))
                            .foregroundStyle(serving == currentServing ? .white : .studioBlackLight)
                            .padding(.horizontal, .horizontalPadding)
                            .frame(height: .height)
                            .background(serving == currentServing ? Color.studioBlackLight : .white)
                            .continiousCornerRadius(.cornerRadius)
                            .border(
                                configuration: .init(
                                    cornerRadius: .cornerRadius,
                                    color: .studioGreyStrokeFill,
                                    lineWidth: serving == currentServing ? 0 : .borderWidth
                                )
                            )
                    }
                }
                Spacer(minLength: .spacerLength)
            }
        }
        .scrollIndicators(.hidden)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 100
    static let borderWidth: CGFloat = 0.5
    static let spacerLength: CGFloat = 10
    static let height: CGFloat = 32
}
