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
    @Dependency(\.cloudStorage) private var cloudStorage

    var body: some View {
        Text("Model name - \(UIDevice.current.modelName)")
        Text("System version - \(UIDevice.current.systemVersion)")
        Text("AccountID - \(accountIdProvider.accountId)")
            .onLongPressGesture {
                UIPasteboard.general.string = accountIdProvider.accountId
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        Text("Locale - \(Locale.current.identifier)")
        Text("W2W account - \(cloudStorage.w2wUserEmail ?? "empty")")
    }
}

#Preview {
    DebugMenuInfoView()
}
