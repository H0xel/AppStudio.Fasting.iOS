//
//  WidgetActionButton.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

public struct WidgetActionButton: View {

    private let title: String
    private let isActive: Bool
    private let onTap: () -> Void

    public init(title: String, isActive: Bool, onTap: @escaping () -> Void) {
        self.title = title
        self.isActive = isActive
        self.onTap = onTap
    }

    public var body: some View {
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
