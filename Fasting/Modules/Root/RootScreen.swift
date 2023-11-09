//  
//  RootScreen.swift
//  Fasting
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
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.step {
        case .onboarding:
            viewModel.onboardingScreen
        case .fasting:
            TabView(selection: $viewModel.currentTab) {
                viewModel.fastingScreen
                    .tag(AppTab.fasting)
                    .tabItem {
                        fastingTabImage
                    }
                viewModel.profileScreen
                    .tag(AppTab.profile)
                    .tabItem {
                        Image.personFill
                    }
                Text("Hello world 3")
                    .tag(AppTab.paywall)
                    .tabItem {
                        Image.crownFill
                    }
            }
            .withDebugMenu()
            .navBarButton(placement: .principal,
                          isVisible: viewModel.currentTab.navigationTitle != nil,
                          content: navigationTitleView,
                          action: {})
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var navigationTitleView: some View {
        if let title = viewModel.currentTab.navigationTitle {
            Text(title)
                .font(.poppins(.buttonText))
        }
    }

    private var fastingTabImage: Image {
        viewModel.currentTab == .fasting ? Image.fastingTabBarItemActive : .fastingTabBarItemInactive
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
        let viewModel = RootViewModel(input: RootInput(step: .fasting), output: { _ in })
        viewModel.router = .init(navigator: .init())
        return RootScreen(viewModel: viewModel)
    }
}
