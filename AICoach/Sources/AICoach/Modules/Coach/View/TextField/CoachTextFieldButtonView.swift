//
//  CoachTextFieldButtonView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI

struct CoachTextFieldButtonView: View {

    let image: Image
    let backgroundColor: Color
    let foregroundColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Circle()
                .fill(backgroundColor)
                .frame(width: .buttonWidth)
                .overlay {
                    image
                        .foregroundStyle(foregroundColor)
                }
        }
    }
}

private extension CGFloat {
    static let buttonWidth: CGFloat = 48
    static let yOffset: CGFloat = 2
}

#Preview {
    CoachTextFieldButtonView(image: .chevronDown,
                             backgroundColor: .gray,
                             foregroundColor: .white,
                             onTap: {})
}
