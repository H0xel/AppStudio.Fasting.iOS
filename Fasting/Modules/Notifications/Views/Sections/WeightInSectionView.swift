//
//  WeightInSectionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioStyles

struct WeightInSectionView: View {
    @Binding var isWeightToggled: Bool
    @Binding var timeToWeight: Date
    @Binding var weightFrequency: WeightFrequency
    @Binding var collapsedType: CollapsedType
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let lockedToggleTapped: (ToggleWithIconStyle.Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                NotificationToggleView(isToggled: $isWeightToggled,
                                       notificationAccessIsGranted: notificationAccessIsGranted,
                                       isLocked: isLocked,
                                       configuration: .remindToWeightIn,
                                       lockedToggleTapped: lockedToggleTapped)
                .padding(.horizontal, .horizontalPadding)

                if isWeightToggled {
                    NotificationSectionDivider()

                    VStack(spacing: .zero) {
                        NotificationDatePickerView(selection: $timeToWeight,
                                                   isCollapsedType: $collapsedType,
                                                   title: "NotificationsScreen.time",
                                                   type: .weighInTime,
                                                   isLocked: isLocked)

                        NotificationSectionDivider()

                        NotificationPickerView(
                            selection: $weightFrequency,
                            isCollapsedType: $collapsedType,
                            title: "NotificationsScreen.frequency",
                            selections: WeightFrequency.allCases,
                            isLocked: isLocked,
                            type: .weighInFrequency
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
    WeightInSectionView(isWeightToggled: .constant(true),
                        timeToWeight: .constant(.now),
                        weightFrequency: .constant(.everyDay),
                        collapsedType: .constant(.weighInTime),
                        notificationAccessIsGranted: false,
                        isLocked: false) { _ in}
}
