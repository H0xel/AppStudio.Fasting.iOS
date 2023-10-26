//
//  DebugMenuInfoView.swift
//  AppStudioTemplate
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import Dependencies

struct DebugMenuInfoView: View {

    @Dependency(\.accountIdProvider) private var accountIdProvider

    var body: some View {
        Text("Model name - \(UIDevice.current.modelName)")
        Text("System version - \(UIDevice.current.systemVersion)")
        Text("AccountID - \(accountIdProvider.accountId)")
    }
}

#Preview {
    DebugMenuInfoView()
}
