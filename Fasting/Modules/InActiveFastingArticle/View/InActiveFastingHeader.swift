//
//  InActiveFastingHeader.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI
import AppStudioUI

struct InActiveFastingHeader: View {
    let action: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            Button {
                action()
            } label: {
                Image.xmarkUnfilled
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .aligned(.centerVerticaly)
            .padding(.leading, Layout.leadingPadding)
            .frame(height: Layout.height)
            Spacer()
        }
        .background(FastingInActiveArticle.linearGradient)
    }
}

private extension InActiveFastingHeader {
    enum Layout {
        static let height: CGFloat = 44
        static let leadingPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 12
    }
}

#Preview {
    InActiveFastingHeader {}
}
