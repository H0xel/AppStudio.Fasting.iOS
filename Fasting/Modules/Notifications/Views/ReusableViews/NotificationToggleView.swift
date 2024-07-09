//
//  NotificationToggleView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioStyles

struct NotificationToggleView: View {
    @Binding var isToggled: Bool
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let configuration: Configuration
    let lockedToggleTapped: (ToggleWithIconStyle.Action) -> Void

    init(isToggled: Binding<Bool>,
         notificationAccessIsGranted: Bool,
         isLocked: Bool,
         configuration: Configuration,
         lockedToggleTapped: @escaping (ToggleWithIconStyle.Action) -> Void) {
        var toggleAvailable: Binding<Bool> {
            if !notificationAccessIsGranted || isLocked {
                return .constant(false)
            }

            return isToggled
        }
        self._isToggled = toggleAvailable
        self.notificationAccessIsGranted = notificationAccessIsGranted
        self.isLocked = isLocked
        self.configuration = configuration
        self.lockedToggleTapped = lockedToggleTapped
    }


    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text(configuration.title)
                    .font(.poppins(.body))
                Spacer()
                Toggle("", isOn: $isToggled)
                    .toggleStyle(ToggleWithIconStyle(systemImage: "lock.fill",
                                                     notificationAccessIsGranted: notificationAccessIsGranted,
                                                     isLocked: isLocked,
                                                     action: lockedToggleTapped))
            }
            if let subTitle = configuration.subTitle {
                Text(subTitle)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyText)
                    .padding(.trailing, .subtitleTrailingPadding)
            }
        }
    }
}

extension CGFloat {
    static let subtitleTrailingPadding: CGFloat = 56
}

extension NotificationToggleView {
    struct Configuration {
        let title: LocalizedStringKey
        let subTitle: LocalizedStringKey?
    }
}

extension NotificationToggleView.Configuration {
    static var quiteMode: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.quite.title",
              subTitle: "NotificationsScreen.quite.subtitle")
    }

    static var startOfFast: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.remindersStart.title",
              subTitle: "NotificationsScreen.remindersStart.subtitle")
    }

    static var endOfFast: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.remindersEnd.title",
              subTitle: "NotificationsScreen.remindersEnd.subtitle")
    }

    static var advanceReminders: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.advanceReminder.title",
              subTitle: "NotificationsScreen.advanceReminder.subtitle")
    }

    static var stageNotifications: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.fastingStages.title",
              subTitle: "NotificationsScreen.fastingStages.subtitle")
    }

    static var remindToWeightIn: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.weightIn.title",
              subTitle: nil)
    }

    static var remindToDrinkWater: NotificationToggleView.Configuration {
        .init(title: "NotificationsScreen.hydrationReminders.title",
              subTitle: nil)
    }
}

#Preview {
    NotificationToggleView(isToggled: .constant(true),
                           notificationAccessIsGranted: true,
                           isLocked: false,
                           configuration: .advanceReminders,
                           lockedToggleTapped: { _ in })
    .padding(.horizontal, 36)
}
