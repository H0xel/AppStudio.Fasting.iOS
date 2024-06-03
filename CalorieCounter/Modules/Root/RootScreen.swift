//  
//  RootScreen.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct RootScreen: View {
    @StateObject var viewModel: RootViewModel

    var body: some View {
        currentView
            .withDebugMenu()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.requestIdfa()
            }
            .withInAppPurchase(status: viewModel.handle)
            .overlay {
                if viewModel.inAppPurchaseIsLoading {
                    DimmedProgressBanner().view
                }
            }
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.rootScreen {
        case .launchScreen:
            LaunchScreen()
        case .onboarding:
            viewModel.onboardingScreen
        case .calorieCounter:
            viewModel.calorieCounterScreen
        case let .forceUpdate(link):
            ForceUpdateScreen(theme: .init()) {
                viewModel.openAppStore(link)
            }
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
        RootScreen(
            viewModel: RootViewModel(
                input: RootInput(),
                output: { _ in }
            )
        )
    }
}
