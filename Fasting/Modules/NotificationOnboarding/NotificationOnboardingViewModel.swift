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
    var router: NotificationOnboardingRouter!

    init(input: NotificationOnboardingInput, output: @escaping NotificationOnboardingOutputBlock) {
        super.init(output: output)
    }

    func notificationButtonTapped() {
        requestAccess()
    }

    private func requestAccess() {
        Task {
            let isGranted = await requestAuthorization()
            output(.onboardingIsFinished)
        }
    }

    private func requestAuthorization() async -> Bool {
        let isGranted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        return isGranted ?? false
    }
}
