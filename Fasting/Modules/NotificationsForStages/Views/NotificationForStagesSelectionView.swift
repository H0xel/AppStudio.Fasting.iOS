//
//  NotificationForStagesSelectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationForStagesSelectionView: View {
    let stage: FastingStage
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: .spacing) {
                    Text(stage.title.capitalized)
                        .font(.poppins(.body))
                    Text(stage.title.capitalized)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGrayText)
                }
                Spacer()
                Image.checkmark
                    .opacity(isSelected ? 1 : 0)
            }
            .padding(.vertical, .verticalPadding)
            .padding(.horizontal, .horizontalPadding)
            RoundedRectangle(cornerSize: .zero)
                .frame(height: .height)
                .foregroundStyle(.white)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

private extension CGFloat {
    static let height: CGFloat = 2
    static let spacing: CGFloat = 4
    static let verticalPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
}

#Preview {
    NotificationForStagesSelectionView(stage: .autophagy, isSelected: true, action: {})
}
