//
//  FastingRemindersSectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioStyles

struct FastingRemindersSectionView: View {
    @Binding var startToFastToggled: Bool
    @Binding var endToFastToggled: Bool
    @Binding var advanceRemindersToggled: Bool
    @Binding var beforeStartPriorSelection: NotificationPrior
    @Binding var beforeEndPriorSelection: NotificationPrior
    @Binding var isCollapsedType: CollapsedType
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let lockedToggleTapped: (ToggleWithIconStyle.Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(
                    isToggled: $startToFastToggled,
                    notificationAccessIsGranted: notificationAccessIsGranted,
                    isLocked: isLocked,
                    configuration: .startOfFast,
                    lockedToggleTapped: lockedToggleTapped
                )
                .padding(.horizontal, .horizontalPadding)

                NotificationSectionDivider()

                NotificationToggleView(
                    isToggled: $endToFastToggled,
                    notificationAccessIsGranted: notificationAccessIsGranted,
                    isLocked: isLocked,
                    configuration: .endOfFast,
                    lockedToggleTapped: lockedToggleTapped
                )
                .padding(.horizontal, .horizontalPadding)
                .padding(.top, .verticalPadding)
            }
            .padding(.vertical, .verticalPadding)
            .withNotificationSectionModifier()
            .padding(.bottom, .bottomPadding)

            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(isToggled: $advanceRemindersToggled,
                                       notificationAccessIsGranted: notificationAccessIsGranted,
                                       isLocked: isLocked,
                                       configuration: .advanceReminders,
                                       lockedToggleTapped: lockedToggleTapped)
                .padding(.horizontal, .horizontalPadding)

                if advanceRemindersToggled {
                    NotificationSectionDivider()

                    VStack(spacing: .zero) {
                        NotificationPickerView(
                            selection: $beforeStartPriorSelection,
                            isCollapsedType: $isCollapsedType,
                            title: "NotificationsScreen.beforeStart",
                            selections: NotificationPrior.allCases,
                            isLocked: isLocked,
                            type: .advanceRemindersBeforeStart
                        )
                        .padding(.horizontal, .horizontalPadding)

                        NotificationSectionDivider()

                        NotificationPickerView(
                            selection: $beforeEndPriorSelection,
                            isCollapsedType: $isCollapsedType,
                            title: "NotificationsScreen.beforeEnd",
                            selections: NotificationPrior.allCases,
                            isLocked: isLocked,
                            type: .advanceRemindersBeforeEnd
                        )
                        .padding(.horizontal, .horizontalPadding)
                    }
                }
            }
            .padding(.vertical, .verticalPadding)
            .withNotificationSectionModifier()
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 8
}

#Preview {
    ZStack {
        Color.red
        FastingRemindersSectionView(
            startToFastToggled: .constant(true),
            endToFastToggled: .constant(true),
            advanceRemindersToggled: .constant(true),
            beforeStartPriorSelection: .constant(.oneHour),
            beforeEndPriorSelection: .constant(.oneHour),
            isCollapsedType: .constant(.advanceRemindersBeforeEnd),
            notificationAccessIsGranted: false,
            isLocked: false,
            lockedToggleTapped: { _ in }
        )
    }
}
