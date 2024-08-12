//
//  ToolbarView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.07.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles

struct ToolbarView: View {

    let items: [ToolbarAction]
    let onTap: (ToolbarAction) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Color.studioGreyStrokeFill
                .frame(height: .borderWidth)
            HStack(spacing: .zero) {
                ToolbarCloseButton {
                    onTap(.close)
                }
                Spacer()
                ForEach(items, id: \.self) { action in
                    Button(action: {
                        onTap(action)
                    }, label: {
                        VStack(spacing: .spacing) {
                            action.image
                                .frame(width: .imageWidth, height: .imageWidth)
                            Text(action.title)
                                .font(.poppins(.mini))
                        }
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.top, .topPadding)
                        .frame(maxWidth: .infinity)
                    })
                    Spacer()
                }
            }
            .padding(.top, .topPadding)
        }
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 8
    static let borderWidth: CGFloat = 0.5
    static let spacing: CGFloat = 8
    static let imageWidth: CGFloat = 24
}

#Preview {
    ToolbarView(items: [.edit, .copyAndCreateNew, .remove]) { _ in }
}
