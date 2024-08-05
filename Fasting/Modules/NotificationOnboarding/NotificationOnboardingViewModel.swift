//  
//  NotificationOnboardingViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies

class NotificationOnboardingViewModel: BaseViewModel<NotificationOnboardingOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.appCustomization) private var appCustomization
    var router: NotificationOnboardingRouter!

    @Published private(set) var title: LocalizedStringKey = "NotificationOnboarding.button.exp"

    init(input: NotificationOnboardingInput, output: @escaping NotificationOnboardingOutputBlock) {
        super.init(output: output)
        trackAllowNotificationsScreenShown()
    }

    func notificationButtonTapped() {
        tapAllowNotification()
        requestAccess()
    }

    private func requestAccess() {
        Task {
            trackPushAccessDialogShown()
            let isGranted = await requestAuthorization()
            trackPushAccessIsAnswered(isGranted: isGranted)

            trackNotificationsScreenTap()
            router.pushNotificationScreen { [weak self] in
                self?.output(.onboardingIsFinished)
            }
        }
    }

    private func requestAuthorization() async -> Bool {
        let isGranted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        await UIApplication.shared.registerForRemoteNotifications()
        return isGranted ?? false
    }
}

private extension NotificationOnboardingViewModel {
    func trackAllowNotificationsScreenShown() {
        trackerService.track(.allowNotificationsScreenShown)
    }

    func tapAllowNotification() {
        trackerService.track(.tapAllowNotifications)
    }

    func trackPushAccessDialogShown() {
        trackerService.track(.pushAccessDialogShown)
    }

    func trackPushAccessIsAnswered(isGranted: Bool) {
        trackerService.track(.pushAccessAnswered(isGranted: isGranted))
    }

    func trackNotificationsScreenTap() {
        trackerService.track(.tapSetUpNotifications(context: .onboarding))
    }
}
