//
//  DebugMenuActionsView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies
import AICoach

struct DebugMenuActionsView: View {

    @Dependency(\.backendEnvironmentService) private var backendEnvironmentService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.storageService) private var storageService
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.coachService) private var coachService

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
    }
}

#Preview {
    DebugMenuActionsView()
}
