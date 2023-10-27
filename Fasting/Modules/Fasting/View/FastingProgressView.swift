//
//  FastingProgressView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

struct FastingProgressView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Circle()
                    .fill(.grayFillProgress)
                    .padding(.horizontal, Layout.horizontalPadding)
                VStack(spacing: Layout.labelsSpacing) {
                    Text(Localization.nextFasIn)
                        .font(.subheadline)
                    Text("01:25:33")
                        .font(.headerSemibold)
                }
            }
            Text("16:8")
                .frame(height: Layout.planTextHeight)
                .font(.footnote)
                .padding(.vertical, Layout.planVerticalPadding)
                .padding(.horizontal, Layout.planHorizontalPadding)
                .background(.white)
                .continiousCornerRadius(Layout.planCornerRadius)
                .border(configuration: .init(cornerRadius: Layout.planCornerRadius,
                                             color: .greyStrokeFill,
                                             lineWidth: Layout.planBorderWidth))
                .offset(y: Layout.planOffset)
        }
        .foregroundColor(.accent)
    }
}

private extension FastingProgressView {
    enum Layout {
        static let horizontalPadding: CGFloat = 15
        static let labelsSpacing: CGFloat = 10
        static let planVerticalPadding: CGFloat = 12
        static let planHorizontalPadding: CGFloat = 20
        static let planCornerRadius: CGFloat = 44
        static let planBorderWidth: CGFloat = 0.5
        static let planTextHeight: CGFloat = 20
        static let planOffset: CGFloat = 22
    }

    enum Localization {
        static let nextFasIn: LocalizedStringKey = "FastingProgressView.nextFastIn"
    }
}

#Preview {
    FastingProgressView()
}
