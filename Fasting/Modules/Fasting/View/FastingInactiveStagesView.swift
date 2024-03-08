//
//  FastingInactiveStagesView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation

struct FastingInActiveStagesView: View {
    let action: (FastingInActiveArticle) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Layout.itemSpacing) {
                Spacer(minLength: Layout.horizontalSpacing)
                ForEach(FastingInActiveArticle.allCases, id: \.self) { stage in
                    Button(action: {
                        action(stage)
                    }, label: {
                        HStack {
                            if let icon = stage.buttonIcon {
                                icon
                                    .padding(.trailing, Layout.iconTrailingPadding)
                            }

                            Text(stage.buttonTitle)
                                .font(.poppins(.buttonText))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, Layout.verticalPadding)
                        .padding(.horizontal, Layout.horizontalPadding)
                        .background(
                            FastingInActiveArticle.linearGradient
                        )
                        .continiousCornerRadius(Layout.cornerRadius)
                    })
                }
                Spacer(minLength: Layout.horizontalSpacing)
            }
        }
    }
}

private extension FastingInActiveStagesView {
    enum Layout {
        static let cornerRadius: CGFloat = 88
        static let verticalPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 24
        static let iconTrailingPadding: CGFloat = 8
        static let horizontalSpacing: CGFloat = 32
        static let itemSpacing: CGFloat = 8
    }
}

#Preview {
    VStack {
        FastingInActiveStagesView { _ in }
    }
}
