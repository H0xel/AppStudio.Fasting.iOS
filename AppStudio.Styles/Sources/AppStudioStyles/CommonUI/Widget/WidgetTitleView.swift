//
//  WidgetTitleView.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioUI

public struct WidgetTitleView: View {

    private let title: String
    private let icon: Image?
    private let onTap: () -> Void

    public init(title: String, icon: Image?, onTap: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.onTap = onTap
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.poppinsBold(.buttonText))
                .foregroundStyle(Color.studioBlackLight)
            Spacer()
            if let icon {
                Button(action: onTap) {
                    icon
                }
            }
        }
    }
}

#Preview {
    WidgetTitleView(title: "Next fast in",
                    icon: nil,
                    onTap: {})
}
