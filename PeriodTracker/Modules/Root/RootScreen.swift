//  
//  RootScreen.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct RootScreen: View {
    @StateObject var viewModel: RootViewModel

    var body: some View {
        VStack {
            Text(Localization.title)
                .withDebugMenu()
            Button("Show Paywall Template") {
                viewModel.showPaywall()
            }
            .padding()
        }
        .onDidBecomeActiveNotification { _ in
            viewModel.requestIdfa()
        }
        .withDebugMenu()
    }
}

// MARK: - Layout properties
private extension RootScreen {
    enum Layout {
    }
}

// MARK: - Localization
private extension RootScreen {
    enum Localization {
        static let title: LocalizedStringKey = "RootScreen"
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen(
            viewModel: RootViewModel(
                input: RootInput(),
                output: { _ in }
            )
        )
    }
}
