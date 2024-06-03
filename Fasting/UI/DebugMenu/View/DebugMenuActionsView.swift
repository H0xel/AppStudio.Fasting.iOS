//
//  DebugMenuActionsView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies
import AICoach
import WeightWidget
import AppStudioServices
import AppStudioABTesting
import FirebaseRemoteConfig

struct DebugMenuActionsView: View {

    @Dependency(\.backendEnvironmentService) private var backendEnvironmentService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.storageService) private var storageService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.coachService) private var coachService
    @Dependency(\.weightService) private var weightService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.weightGoalService) private var weightGoalService
    @Dependency(\.localNotificationService) private var localNotificationService
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    let onboarding = OnboardingApiImpl()

    @State private var isDeletingMessages = false

    @State private var currentEnvironment: BackendEnvironment

    init() {
        @Dependency(\.backendEnvironmentService) var backendEnvironmentService
        currentEnvironment = backendEnvironmentService.currentEnvironment
    }

    var body: some View {
        Picker("", selection: $currentEnvironment) {
            ForEach(backendEnvironmentService.environments, id: \.self) {
                Text($0.rawValue)
            }
        }
        .onChange(of: currentEnvironment) { newValue in
            backendEnvironmentService.change(to: newValue)
        }
        .pickerStyle(.segmented)
        Button("Copy userID") {
            UIPasteboard.general.string = """
        accountID - \(accountIdProvider.accountId)
        """
        }
        Button("Clear userID from iCloud") {
            cloudStorage.clearAllData()
        }
        .foregroundColor(.red)
        Button("Crash application") {
            fatalError("Crash for testing crashlytics")
        }
        .foregroundColor(.red)

        Button("Reset onboarding") {
            storageService.onboardingIsFinished = false
            onboardingService.reset()
        }

        Button("Reset discount paywall timer") {
            discountPaywallTimerService.reset()
        }

        HStack {
            Button("Delete all messages from AI Coach") {
                isDeletingMessages = true
                Task {
                    try await coachService.deleteAllMessages()
                    coachService.reset()
                    isDeletingMessages = false
                }
            }
            Spacer()
            if isDeletingMessages {
                ProgressView()
            }
        }
        Button("Delete all weights", role: .destructive) {
            Task {
                try await weightService.deleteAll()
            }
        }
        Button("Delete all fasting history", role: .destructive) {
            Task {
                try await fastingHistoryService.deleteAll()
            }
        }
        Button("Delete all weight goals", role: .destructive) {
            Task {
                try await weightGoalService.deleteAll()
            }
        }
        Button("Register discount notification push 5 sec") {
            Task {
                let nextStartingDate = Date().addingTimeInterval(.second * 5)

                try await localNotificationService.register(DiscountLocalNotification(),
                                                            at: .init(year: nextStartingDate.year,
                                                                      month: nextStartingDate.month,
                                                                      day: nextStartingDate.day,
                                                                      hour: nextStartingDate.hour,
                                                                      minute: nextStartingDate.minute,
                                                                      second: nextStartingDate.second))
            }
        }
    }
}

#Preview {
    DebugMenuActionsView()
}
