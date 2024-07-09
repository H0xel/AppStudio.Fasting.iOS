//
//  FastingStagesSectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import Foundation

struct FastingStagesSectionView: View {
    @Binding var isFastingStagesToggled: Bool
    let selectedFastingStages: [FastingStage]
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let action: (Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(isToggled: $isFastingStagesToggled,
                                       notificationAccessIsGranted: notificationAccessIsGranted,
                                       isLocked: isLocked,
                                       configuration: .stageNotifications) { event in
                    switch event {
                    case .isLocked:
                        action(.lockedToggleTapped)
                    case .notificationsAccessNotGranted:
                        action(.notificationsAccessNotGranted)
                    }
                }
                .padding(.horizontal, .horizontalPadding)

                if isFastingStagesToggled {
                    NotificationSectionDivider()

                    HStack(spacing: .zero) {
                        Text("NotificationsScreen.selectStages")
                            .foregroundStyle(isLocked ? Color.placeholderText : Color.studioBlackLight)
                        Spacer()
                        Text(selectedFastingStages.localizedDescription)
                            .foregroundStyle(isLocked ? Color.placeholderText : Color.studioGreyText)
                            .onTapGesture {
                                action(.showFastingStages)
                            }
                    }
                    .font(.poppins(.body))
                    .padding(.top, .topPadding)
                    .padding(.horizontal, .horizontalPadding)
                }
            }
            .padding(.vertical, .verticalPadding)
        }
    }
}

extension FastingStagesSectionView {
    enum Action {
        case showFastingStages
        case lockedToggleTapped
        case notificationsAccessNotGranted
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let dividerHeight: CGFloat = 1
    static let topPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 8
}

private extension [FastingStage] {
    var localizedDescription: String {
        if count == 6 {
            return "NotificationsScreen.allStages".localized()
        }

        if count < 2 {
            return count.description + " " + "NotificationsScreen.stage".localized()
        }

        return count.description + " " + "NotificationsScreen.stages".localized()
    }
}

#Preview {
    FastingStagesSectionView(isFastingStagesToggled: .constant(true),
                             selectedFastingStages: [.autophagy, .burning],
                             notificationAccessIsGranted: false,
                             isLocked: false,
                             action: { _ in })
}
