//
//  FastingPhaseTitleView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 05.12.2023.
//

import SwiftUI

struct FastingPhaseTitleView: View {

    let title: String
    let backgroundColor: Color
    let image: Image
    let isLocked: Bool

    var body: some View {
        VStack(spacing: .zero) {
            Text(title)
                .font(.poppins(.headerL))
                .foregroundStyle(.white)
                .padding(.top, Layout.titleTopPadding)
                .padding(.bottom, Layout.titleBottomPadding)
                .aligned(.left)

            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blur(radius: isLocked ? Layout.blurRadius : .zero)
                .padding(.bottom, Layout.logoBottomPadding)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .background(backgroundColor)
    }
}

private extension FastingPhaseTitleView {
    enum Layout {
        static let titleTopPadding: CGFloat = 16
        static let titleBottomPadding: CGFloat = 24
        static let logoBottomPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 32
        static let blurRadius: CGFloat = 18
    }
}

#Preview {
    FastingPhaseTitleView(title: "Blood sugar slowly rises",
                          backgroundColor: .blue, 
                          image: .init(.sugarDownArticle), 
                          isLocked: false)
}
