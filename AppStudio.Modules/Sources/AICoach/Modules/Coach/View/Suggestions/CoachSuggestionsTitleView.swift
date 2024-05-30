//
//  CoachSuggestionsTitleView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI

struct CoachSuggestionsTitleView: View {

    let styles: CoachStyles
    let onTap: () -> Void
    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack(spacing: .verticalSpacing) {
            Color.studioGreyStrokeFill
                .frame(width: .lineWidth, height: .lineHeight)
            HStack {
                Text(String.title)
                    .font(styles.fonts.body.weight(.medium))
                    .foregroundStyle(styles.colors.coachGrayText)
                    .padding(.leading, .titleLeadingPadding)
                Spacer()
                Button {
                    rotationAngle -= 360
                    onTap()
                } label: {
                    HStack(spacing: .spacing) {
                        Image.arrowCirclepath
                            .font(styles.fonts.description.weight(.semibold))
                            .rotationEffect(.degrees(rotationAngle))
                        Text(String.more)
                            .font(styles.fonts.description)
                    }

                    .foregroundStyle(styles.colors.accent)
                    .padding(.leading, .leadingPadding)
                    .padding(.trailing, .trailingPadding)
                    .frame(height: .height)
                    .background(styles.colors.coachGrayFillProgress)
                    .continiousCornerRadius(.height)
                    .animation(.bouncy, value: rotationAngle)
                }
            }
        }
    }
}

private extension CGFloat {
    static let titleLeadingPadding: CGFloat = 8
    static let spacing: CGFloat = 8
    static let leadingPadding: CGFloat = 16
    static let trailingPadding: CGFloat = 20
    static let height: CGFloat = 44
    static let verticalSpacing: CGFloat = 9
    static let lineWidth: CGFloat = 32
    static let lineHeight: CGFloat = 2
}

private extension String {
    static let more = "CoachSuggestionsView.more".localized(bundle: .coachBundle)
    static let title = "CoachSuggestionsView.title".localized(bundle: .coachBundle)
}

#Preview {
    CoachSuggestionsTitleView(styles: .mock) {}
}
