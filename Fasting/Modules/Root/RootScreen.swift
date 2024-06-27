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
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        currentView
            .withDebugMenu()
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    viewModel.requestIdfa()
                }
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
                    // uncommit after relsease 1.2.4
//                    viewModel.exploreScreen
//                        .tag(AppTab.explore)
//                        .tabItem {
//                            tabBarLabelView(title: .explore, image: exploreTabImage)
//                        }
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
        viewModel.currentTab == .fasting ? .init(.fastingActiveIcon) : .init(.fastingNonActiveIcon)
    }

    private var coachTabImage: Image {
        viewModel.currentTab == .coach ? .init(.aiCoachActive) : .init(.aiCoachDisabled)
    }

    private var progressTabImage: Image {
        viewModel.currentTab == .healthProgress ? .progressTabActive : .progressTabInActive
    }

    private var exploreTabImage: Image {
        viewModel.currentTab == .explore ? .init(.exploreActive) : .init(.exploreInActive)
    }
}

private extension LocalizedStringKey {
    static let daily: LocalizedStringKey = "RootScreen.TabBar.daily"
    static let fasting: LocalizedStringKey = "RootScreen.TabBar.fasting"
    static let nova: LocalizedStringKey = "RootScreen.TabBar.nova"
    static let progress: LocalizedStringKey = "RootScreen.TabBar.progress"
    static let plus: LocalizedStringKey = "RootScreen.TabBar.plus"
    static let explore: LocalizedStringKey = "RootScreen.TabBar.explore"
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RootViewModel(router: .init(navigator: .init()), input: .init(), output: { _ in })
        return RootScreen(viewModel: viewModel)
    }
}
