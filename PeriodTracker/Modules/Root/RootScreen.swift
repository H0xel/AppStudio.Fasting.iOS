//  
//  RootScreen.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioServices

struct RootScreen: View {
    @StateObject var viewModel: RootViewModel

    var body: some View {
        currentView
            .onDidBecomeActiveNotification { _ in
                viewModel.requestIdfa()
            }
            .withInAppPurchase(status: viewModel.handle)
            .withDebugMenu()
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.rootScreen {
        case let .forceUpdate(link):
            ForceUpdateScreen(theme: .init()) {
                viewModel.openAppStore(link)
            }
        case .launchScreen:
            LaunchScreen()
        case .onboarding:
            viewModel.onboardingScreen
        case .periodTracker:
            TabBarView()
        }
        if viewModel.isProcessingSubscription {
            DimmedProgressBanner().view
        }
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
        RootScreen(viewModel: RootViewModel())
    }
}
