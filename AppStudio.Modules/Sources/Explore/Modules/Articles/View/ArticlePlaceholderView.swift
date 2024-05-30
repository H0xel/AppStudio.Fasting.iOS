//
//  ArticlePlaceholderView.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles

struct ArticlePlaceholderView: View {

    let backgroundColor: Color
    let size: ArticleStackSize
    @State private var gradientLocation: CGFloat = 0
    @State private var viewWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: .imageBottomPadding) {
            ArticleImagePlaceholderView(backgroundColor: backgroundColor,
                                        height: imageHeight,
                                        width: viewSize.width)
            VStack(alignment: .leading, spacing: 6) {
                PlaceholderGradient(currentLocation: gradientLocation,
                                    height: .lineHeight)
                PlaceholderGradient(currentLocation: gradientLocation,
                                    height: .lineHeight)
                .frame(width: viewWidth / 2.8 * 2)
                Spacer(minLength: .titleBottomSpacing)
                PlaceholderGradient(currentLocation: gradientLocation,
                                    height: .lineHeight)
                    .frame(width: viewWidth / 2.7)
            }
            .withViewWidthPreferenceKey
            .padding(.horizontal, .horizontalPadding)
            .padding(.bottom, .bottomPadding)

        }
        .frame(width: viewSize.width, height: viewSize.height)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
        .modifier(WithGradientLocationTimerModifier(gradientLocation: $gradientLocation))
        .onViewWidthPreferenceKeyChange { newWidth in
            viewWidth = newWidth
        }
    }

    private var viewSize: CGSize {
        switch size {
        case .small: .init(width: 160, height: 283)
        case .large: .init(width: 328, height: 339)
        }
    }

    private var imageHeight: CGFloat {
        switch size {
        case .small: 160
        case .large: 240
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let imageBottomPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 16
    static let titleBottomSpacing: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let lineHeight: CGFloat = 20
}

#Preview {
    ZStack {
        Color.red
        VStack {
            ArticlePlaceholderView(backgroundColor: .studioRed, size: .small)
            ArticlePlaceholderView(backgroundColor: .studioRed, size: .large)
        }
    }


}
