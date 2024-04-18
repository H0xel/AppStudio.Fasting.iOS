//
//  CoachNavigationView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

struct CoachNavigationView: View {

    @Dependency(\.styles) private var styles

    var body: some View {
        VStack(spacing: .verticalPadding) {
            HStack {
                styles.images.coachIcon
                Spacer()
                VStack(spacing: .titleSpacing) {
                    Text(String.title)
                        .font(styles.fonts.buttonText)
                        .foregroundStyle(styles.colors.accent)
                    Text(String.subtitle)
                        .font(styles.fonts.description)
                        .foregroundStyle(styles.colors.coachGrayPlaceholder)
                }
                Spacer()
                Spacer()
                    .frame(width: .imageWidth)
            }
            .padding(.horizontal, .horizontalPadding)
            .padding(.top, .verticalPadding)
            styles.colors.coachGreyStrokeFill
                .frame(height: .borderHeight)
        }
    }
}

private extension String {
    static let title = "CoachNavigationView.title".localized(bundle: .coachBundle)
    static let subtitle = "CoachNavigationView.subtitle".localized(bundle: .coachBundle)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let imageWidth: CGFloat = 44
    static let titleSpacing: CGFloat = 2
    static let verticalPadding: CGFloat = 6
    static let borderHeight: CGFloat = 0.5
}

#Preview {
    CoachNavigationView()
        .aligned(.top)
}
