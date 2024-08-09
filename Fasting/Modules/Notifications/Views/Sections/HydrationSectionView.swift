//
//  HydrationSectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioStyles

struct HydrationSectionView: View {
    @Binding var isHydrationToggled: Bool
    @Binding var timeToDrink: Date
    @Binding var endTimeToDrink: Date
    @Binding var hydrationFrequency: HydrationFrequency
    @Binding var collapsedType: CollapsedType
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let lockedToggleTapped: (ToggleWithIconStyle.Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(isToggled: $isHydrationToggled,
                                       notificationAccessIsGranted: notificationAccessIsGranted,
                                       isLocked: isLocked,
                                       configuration: .remindToDrinkWater,
                                       lockedToggleTapped: lockedToggleTapped)
                .padding(.horizontal, .horizontalPadding)

                if isHydrationToggled {
                    NotificationSectionDivider()

                    VStack(spacing: .zero) {
                        NotificationDatePickerView(selection: $timeToDrink,
                                                   isCollapsedType: $collapsedType,
                                                   title: "NotificationsScreen.startTime",
                                                   type: .hydrationStartTime,
                                                   isLocked: isLocked)

                        NotificationSectionDivider()

                        NotificationDatePickerView(selection: $endTimeToDrink,
                                                   isCollapsedType: $collapsedType,
                                                   title: "NotificationsScreen.endTime",
                                                   type: .hydrationEndTime,
                                                   isLocked: isLocked)

                        NotificationSectionDivider()

                        NotificationPickerView(
                            selection: $hydrationFrequency,
                            isCollapsedType: $collapsedType,
                            title: "NotificationsScreen.frequency",
                            selections: HydrationFrequency.allCases,
                            isLocked: isLocked,
                            type: .hydrationFrequency
                        )
                        .padding(.horizontal, .horizontalPadding)
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
    HydrationSectionView(isHydrationToggled: .constant(true),
                         timeToDrink: .constant(.now),
                         endTimeToDrink: .constant(.now),
                         hydrationFrequency: .constant(.everyFiveHours),
                         collapsedType: .constant(.advanceRemindersBeforeEnd),
                         notificationAccessIsGranted: false,
                         isLocked: false) { _ in }
}
