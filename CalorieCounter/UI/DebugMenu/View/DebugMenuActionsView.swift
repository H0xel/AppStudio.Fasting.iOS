//
//  DebugMenuActionsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies

struct DebugMenuActionsView: View {

    @Dependency(\.backendEnvironmentService) private var backendEnvironmentService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.userDataService) private var userDataService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    @State private var currentEnvironment: BackendEnvironment
    @State private var isSubscriptionEnabled: Bool

    init() {
        @Dependency(\.backendEnvironmentService) var backendEnvironmentService
        @Dependency(\.storageService) var storageService
        currentEnvironment = backendEnvironmentService.currentEnvironment
        self.isSubscriptionEnabled = storageService.isSubscriptionEnabled
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

        Toggle("Subscription On", isOn: $isSubscriptionEnabled)
            .onChange(of: isSubscriptionEnabled) { newValue in
                @Dependency(\.storageService) var storageService
                storageService.isSubscriptionEnabled = newValue
            }

        Button("Reset onboarding") {
            cloudStorage.onboardingIsFinished = false
            userDataService.removeAllData()
        }

        Button("Reset discount paywall timer") {
            discountPaywallTimerService.reset()
        }
        Button("Crash application") {
            fatalError("Crash for testing crashlytics")
        }
        .foregroundColor(.red)
    }
}

#Preview {
    DebugMenuActionsView()
}