//
//  DebugMenuInfoView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies
import AppStudioSubscriptions

struct DebugMenuInfoView: View {

    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.subscriptionService) private var subscriptionService

    @State private var actualSubType: ActualSubscriptionType?

    var body: some View {
        Text("Model name - \(UIDevice.current.modelName)")
        Text("System version - \(UIDevice.current.systemVersion)")
        Text("AccountID - \(accountIdProvider.accountId)")
        Text("Locale - \(Locale.current.identifier)")

        Text("Current subscription \(actualSubType.debugDescription)")
            .task {
                Task {
                    actualSubType = try await subscriptionService.actualSubscription.first().value
                }
            }
    }
}

#Preview {
    DebugMenuInfoView()
}
