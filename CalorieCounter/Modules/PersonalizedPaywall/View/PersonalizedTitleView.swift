//
//  PersonalizedTitleView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedTitleView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            Text(viewData.title)
                .padding(.top, Layout.topPadding)
                .font(.poppins(.headerM))
                .foregroundStyle(.accent)
            Text(viewData.description)
                .font(.poppins(.body))
                .foregroundColor(.studioGrayText)
                .padding(.vertical, Layout.verticalPadding)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

extension PersonalizedTitleView {
    struct ViewData {
        let title: String
        let description: String
    }

    private enum Layout {
        static let topPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 32
        static let verticalPadding: CGFloat = 24
    }
}

#Preview {
    PersonalizedTitleView(viewData: .init(title: "Something", description: "Something 2"))
}
