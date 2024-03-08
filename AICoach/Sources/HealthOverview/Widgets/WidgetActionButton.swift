//
//  WidgetActionButton.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

struct WidgetActionButton: View {

    let title: String
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(isActive ? Color.white : .studioBlackLight)
                .frame(height: .height)
                .frame(maxWidth: .infinity)
                .background(isActive ? Color.studioBlackLight : .studioGrayFillProgress)
                .continiousCornerRadius(.cornerRadius)
        }
    }
}

private extension CGFloat {
    static let height: CGFloat = 44
    static let cornerRadius: CGFloat = 44
}

#Preview {
    WidgetActionButton(title: "Start fasting",
                       isActive: true,
                       onTap: {})
}
