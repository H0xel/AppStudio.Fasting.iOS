//
//  QuiteModeSectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioStyles

struct QuiteModeSectionView: View {
    @Binding var isQuietModeToggled: Bool
    @Binding var fromTimeSelected: Date
    @Binding var toTomeSelected: Date
    @Binding var isCollapsedType: CollapsedType
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let lockedToggleTapped: (ToggleWithIconStyle.Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(isToggled: $isQuietModeToggled,
                                       notificationAccessIsGranted: notificationAccessIsGranted,
                                       isLocked: isLocked,
                                       configuration: .quiteMode,
                                       lockedToggleTapped: lockedToggleTapped)
                .padding(.horizontal, .horizontalPadding)

                if isQuietModeToggled {
                    NotificationSectionDivider()

                    VStack(spacing: .zero) {
                        NotificationDatePickerView(selection: $fromTimeSelected,
                                                   isCollapsedType: $isCollapsedType,
                                                   title: "NotificationsScreen.quite.from",
                                                   type: .quiteModeFrom,
                                                   isLocked: isLocked)

                        NotificationSectionDivider()

                        NotificationDatePickerView(selection: $toTomeSelected,
                                                   isCollapsedType: $isCollapsedType,
                                                   title: "NotificationsScreen.quite.to",
                                                   type: .quiteModeTo,
                                                   isLocked: isLocked)
                    }
                }
            }
            .padding(.vertical, .verticalPadding)
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
}

#Preview {
    QuiteModeSectionView(isQuietModeToggled: .constant(true),
                         fromTimeSelected: .constant(.now),
                         toTomeSelected: .constant(.now),
                         isCollapsedType: .constant(.advanceRemindersBeforeEnd),
                         notificationAccessIsGranted: false,
                         isLocked: false) { _ in }
}
