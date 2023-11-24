//
//  MonoSpacedView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 21.11.2023.
//

import SwiftUI

struct MonoSpacedView: View {
    let digit: String

    var body: some View {
        HStack(spacing: .zero) {
            Spacer(minLength: Layout.minSpacing)
            Text(digit)
                .font(.poppins(.accentS))
                .fontWidth(.expanded)
            Spacer(minLength: Layout.minSpacing)
        }
        .frame(width: Layout.width)
    }
}

private extension MonoSpacedView {
    enum Layout {
        static let width: CGFloat = 25
        static let minSpacing: CGFloat = 1
    }
}

#Preview {
    MonoSpacedView(digit: "1")
}
