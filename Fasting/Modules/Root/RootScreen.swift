//  
//  RootScreen.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import HealthProgress

struct RootScreen: View {

    @StateObject var viewModel: RootViewModel

    var body: some View {
        currentView
            .withDebugMenu()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.requestIdfa()
            }
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.rootScreen {
        case .launchScreen:
            LaunchScreen()
        case .onboarding:
            viewModel.onboardingScreen
        case .fasting:
            ZStack {
                TabView(selection: $viewModel.currentTab) {
                    viewModel.fastingScreen
                        .tag(AppTab.fasting)
                        .tabItem {
                            tabBarLabelView(title: .fasting, image: fastingTabImage)
                                .foregroundStyle(Color.studioGreyStrokeFill)
                        }
                    viewModel.coachScreen
                        .tag(AppTab.coach)
                        .tabItem {
                            tabBarLabelView(title: .nova, image: coachTabImage)
                        }
                    viewModel.healthProgressScreen
                        .tag(AppTab.healthProgress)
                        .tabItem {
                            tabBarLabelView(title: .progress, image: progressTabImage)
                        }
                    viewModel.profileScreen
                        .tag(AppTab.profile)
                        .tabItem {
                            tabBarLabelView(title: .profile, image: .personFill)
                        }
                    if !viewModel.hasSubscription {
                        if let info = viewModel.discountPaywallInfo {
                            viewModel.discountPaywall(input: .init(context: .discountPaywallTab, paywallInfo: info))
                                .tag(AppTab.paywall)
                                .tabItem {
                                    tabBarLabelView(title: .plus, image: .crownFill)
                                }
                        } else {
                            viewModel.paywallScreen
                                .tag(AppTab.paywall)
                                .tabItem {
                                    tabBarLabelView(title: .plus, image: .crownFill)
                                }
                        }
                    }
                }
                if viewModel.isProcessingSubcription {
                    DimmedProgressBanner().view
                }
            }
        case let .forceUpdate(link):
            ForceUpdateScreen(theme: .init()) {
                viewModel.openAppStore(link)
            }
        }
    }

    private func tabBarLabelView(title: LocalizedStringKey, image: Image) -> some View {
        Label(
            title: {
                Text(title)
                    .font(.poppins(9))
                    .foregroundStyle(.accent)
            },
            icon: { image }
        )
    }

    private var fastingTabImage: Image {
        viewModel.currentTab == .fasting ? .fastingTabBarItemActive : .fastingTabBarItemInactive
    }

    private var coachTabImage: Image {
        viewModel.currentTab == .coach ? .init(.aiCoachActive) : .init(.aiCoachDisabled)
    }

    private var progressTabImage: Image {
        viewModel.currentTab == .healthProgress ? .progressTabActive : .progressTabInActive
    }
}

private extension LocalizedStringKey {
    static let daily: LocalizedStringKey = "RootScreen.TabBar.daily"
    static let fasting: LocalizedStringKey = "RootScreen.TabBar.fasting"
    static let nova: LocalizedStringKey = "RootScreen.TabBar.nova"
    static let progress: LocalizedStringKey = "RootScreen.TabBar.progress"
    static let profile: LocalizedStringKey = "RootScreen.TabBar.profile"
    static let plus: LocalizedStringKey = "RootScreen.TabBar.plus"
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RootViewModel(input: .init(), output: { _ in })
        viewModel.router = .init(navigator: .init())
        return RootScreen(viewModel: viewModel)
    }
}
