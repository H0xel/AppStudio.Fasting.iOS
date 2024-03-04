//
//  InActiveFastingListView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI

struct InActiveFastingListView: View {
    let text: LocalizedStringKey

    var body: some View {
        HStack(spacing: .zero) {
            Image.diamondFill
                .foregroundStyle(Color.studioSky)
                .font(.system(size: Layout.imageSize))
                .padding(.vertical, Layout.verticalImagePadding)
                .padding(.trailing, Layout.imageTrailingPadding)
                .aligned(.topLeft)
            Text(text)
                .padding(.bottom, Layout.textBottomPadding)
                .multilineTextAlignment(.leading)
                .font(.poppins(.body))
                .lineSpacing(Layout.lineSpacing)
                .aligned(.left)
        }
    }
}

private extension InActiveFastingListView {
    enum Layout {
        static let textBottomPadding: CGFloat = 20
        static let lineSpacing: CGFloat = 2
        static let verticalImagePadding: CGFloat = 7
        static let imageSize: CGFloat = 8
        static let imageTrailingPadding: CGFloat = 22
    }
}

#Preview {
    InActiveFastingListView(text: "InActiveFastingArticle.list.howToPrepareForFasting.1")
}
