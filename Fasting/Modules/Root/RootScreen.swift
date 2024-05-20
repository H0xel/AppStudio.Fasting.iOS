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
import AppStudioServices

struct RootScreen: View {

    @StateObject var viewModel: RootViewModel

    var body: some View {
        currentView
            .withDebugMenu()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.requestIdfa()
            }
            .withInAppPurchase(status: viewModel.handle)
            .withDeepLink(deepLink: viewModel.handle)
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.rootScreen {
        case .launchScreen:
            LaunchScreen()
        case .onboarding:
            ZStack {
                viewModel.onboardingScreen
                if viewModel.isProcessingSubcription {
                    DimmedProgressBanner().view
                }
            }
        case .fasting:
            ZStack {
                TabView(selection: $viewModel.currentTab) {
                    viewModel.healthOverviewScreen
                        .tag(AppTab.daily)
                        .tabItem {
                            tabBarLabelView(title: .daily, image: healthOverviewTabImage)
                        }
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

                    if !viewModel.hasSubscription, !viewModel.monetizationExpAvailable {
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

    private var healthOverviewTabImage: Image {
        viewModel.currentTab == .daily ? .init(.dailyTabActive) : .init(.dailyTabInActive)
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
    static let plus: LocalizedStringKey = "RootScreen.TabBar.plus"
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RootViewModel(router: .init(navigator: .init()), input: .init(), output: { _ in })
        return RootScreen(viewModel: viewModel)
    }
}
