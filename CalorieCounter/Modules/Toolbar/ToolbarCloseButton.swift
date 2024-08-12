//
//  ToolbarCloseButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.07.2024.
//

import SwiftUI

struct ToolbarCloseButton: View {

    let onTap: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            Button(action: onTap) {
                Image.bannerCloseButton
                    .resizable()
                    .frame(width: .buttonWidth, height: .buttonWidth)
                    .padding(.horizontal, .horizontalPadding)
                    .padding(.vertical, .verticalPadding)
            }
            Color.studioGreyStrokeFill
                .frame(width: .lineWidth, height: .lineHeight)
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 11
    static let buttonWidth: CGFloat = 24
    static let lineWidth: CGFloat = 0.5
    static let lineHeight: CGFloat = 46
}

#Preview {
    ToolbarCloseButton {}
}
