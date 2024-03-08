//
//  FastingPhaseStartDescriptionView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 02.12.2023.
//

import SwiftUI

struct FastingPhaseStartDescriptionView: View {

    let title: String
    let backgroundColor: Color

    var body: some View {
        HStack(spacing: Layout.spacing) {
            Image.clockFill
            Text(title)
        }
        .foregroundStyle(.white)
        .font(.poppins(.body))
        .padding(Layout.padding)
        .background(backgroundColor)
        .continiousCornerRadius(Layout.cornerRadius)
    }
}

private extension FastingPhaseStartDescriptionView {
    enum Layout {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }
}

#Preview {
    FastingPhaseStartDescriptionView(title: "Begins right after your last meal",
                                     backgroundColor: .blue)
}
