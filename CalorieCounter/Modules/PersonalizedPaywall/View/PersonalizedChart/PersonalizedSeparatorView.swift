//
//  PersonalizedSeparatorView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedSeparatorView: View {
    let endDate: String

    var body: some View {
        VStack(spacing: Layout.spacing) {
            Divider()
                .frame(height: Layout.dividerHeight)
                .foregroundStyle(Color.studioGreyStrokeFill)

            HStack(spacing: .zero) {
                Text(Localization.now)
                Spacer()
                Text(endDate)
            }
            .font(.poppins(.description))
            .padding(.bottom, Layout.bottomPadding)
        }
        .padding(.leading, Layout.leadingPadding)
        .padding(.trailing, Layout.trailingPadding)
        .aligned(.bottom)
    }
}

private extension PersonalizedSeparatorView {
    enum Layout {
        static let spacing: CGFloat = 11
        static let dividerHeight: CGFloat = 1
        static let bottomPadding: CGFloat = 20
        static let leadingPadding: CGFloat = 24
        static let trailingPadding: CGFloat = 26
    }


    private enum Localization {
        static let now = NSLocalizedString("PersonalizedPaywall.now", comment: "")
    }
}

#Preview {
    PersonalizedSeparatorView(endDate: "Feb 14")
}
