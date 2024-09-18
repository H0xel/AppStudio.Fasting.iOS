//
//  DebugMenuActionsView.swift
//  AppStudioTemplate
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies

struct DebugMenuActionsView: View {

    @Dependency(\.backendEnvironmentService) private var backendEnvironmentService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.onboardingUserDataService) private var onboardingUserDataService

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

        Button("Reset onboarding") {
            cloudStorage.onboardingIsFinished = false
            onboardingUserDataService.reset()
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
