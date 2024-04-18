//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//

import SwiftUI

struct WaterCounterSettingsItemView: View {
    let icon: Image
    let title: String
    let valueTitle: String
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: .spacing) {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .iconSize, height: .iconSize)
                .padding(.leading, .iconLeadingPadding)
                .padding(.vertical, .iconVerticalPadding)

            Text(title)
                .font(.poppins(.body))
                .foregroundStyle(Color.studioBlackLight)

            Spacer()

            Text(valueTitle)
                .font(.poppins(.body))
                .foregroundStyle(Color.studioGreyText)

            Image.chevronRight
                .foregroundStyle(Color.studioGreyStrokeFill)
                .padding(.trailing, .iconVerticalPadding)

        }
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .background(Color.studioGreyFillCard)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let iconSize: CGFloat = 24
    static let iconLeadingPadding: CGFloat = 20
    static let iconVerticalPadding: CGFloat = 16
}

#Preview {
    WaterCounterSettingsItemView(icon: .glass, title: "Test", valueTitle: "Liters", onTap: {})
}
