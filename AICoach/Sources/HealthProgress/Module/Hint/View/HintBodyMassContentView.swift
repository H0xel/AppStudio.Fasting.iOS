//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 08.03.2024.
//

import SwiftUI

struct HintBodyMassContentView: View {
    let bodyMassContent: BodyMassContent

    var body: some View {
        VStack(spacing: .spacing) {
            HStack {
                Text(bodyMassContent.title)
                    .font(.poppinsMedium(.body))
                Spacer()
            }
            HStack {
                Text(bodyMassContent.index.title)
                    .font(.poppinsMedium(.body))
                    .frame(height: .badgeHeight)
                    .padding(.vertical, .badgeVerticalPadding)
                    .padding(.horizontal, .badgeHorizontalPadding)
                    .foregroundStyle(Color.white)
                    .background(bodyMassContent.index.color)
                    .continiousCornerRadius(.badgeCornerRadius)
                Spacer()
            }
        }
        .padding(.bottom, .titleBottomPadding)

        VStack(alignment: .leading, spacing: .descriptionsSpacing) {
            ForEach(bodyMassContent.index.fullDescriptions, id: \.self) { answear in
                Text(answear)
                    .font(.poppins(.body))
            }
        }
        .padding(.bottom, .bottomPadding)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let spacing: CGFloat = 8
    static let descriptionsSpacing: CGFloat = 12
    static let badgeCornerRadius: CGFloat = 32
    static let badgeVerticalPadding: CGFloat = 4
    static let badgeHorizontalPadding: CGFloat = 16
    static let badgeHeight: CGFloat = 24

    static let topPadding: CGFloat = 32

    static let titleBottomPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 24
}

#Preview {
    HintBodyMassContentView(bodyMassContent: BodyMassContent(title: "title", index: .normal))
}
