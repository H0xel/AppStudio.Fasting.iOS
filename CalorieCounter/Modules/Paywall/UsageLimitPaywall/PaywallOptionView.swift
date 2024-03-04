//
//  PaywallOptionView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import SwiftUI
import AppStudioUI

struct PaywallOptionView: View {

    let product: SubscriptionProduct
    let title: LocalizedStringKey?
    let weekTitle: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: .zero) {
            ZStackWith(color: backgroundColor) {
                if let title {
                    Text(title)
                        .font(.poppins(.description))
                        .foregroundStyle(isSelected ? .white : .accentColor)
                }
            }
            .frame(height: .optionHeaderHeight)
            .corners([.topLeft, .topRight], with: .cornerRadius)

            Spacer()
                .frame(minHeight: .spacing, maxHeight: .verticalPadding)
            VStack(spacing: .spacing) {
                Text(product.durationTitle)
                    .font(.poppins(.body))
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
                Text(product.price)
                    .font(.poppins(.description))
                    .foregroundStyle(.accent)
                Text(weekTitle)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyPlaceholder)
            }
            Spacer()
                .frame(minHeight: .spacing, maxHeight: .verticalPadding)

            if let promotion = product.promotion {
                Text(promotion)
                    .font(.poppins(.body))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.studioRed)
                    .frame(height: .lineHeight)
                    .padding(.bottom, .bottomPadding)
            } else {
                Color.clear
                    .frame(height: .lineHeight)
                    .padding(.bottom, .bottomPadding)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: .cornerRadius)
                .stroke(isSelected ? Color.studioRed : .studioGreyStrokeFill,
                        lineWidth: isSelected ? .selectedBorderWidth : .notSelectedBorderWidth)
        )
    }

    private var backgroundColor: Color {
        if title == nil {
            return .clear
        }
        return isSelected ? Color.studioRed : .studioGreyFillProgress
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 16
    static let spacing: CGFloat = 8
    static let selectedBorderWidth: CGFloat = 2
    static let notSelectedBorderWidth: CGFloat = 0.5
    static let optionHeaderHeight: CGFloat = 31
    static let cornerRadius: CGFloat = 20
    static let lineHeight: CGFloat = 18
}
