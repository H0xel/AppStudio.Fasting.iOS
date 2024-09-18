//  
//  RootRouter.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class RootRouter: BaseRouter {
    @Dependency(\.openURL) private var openURL
    private let onboardingNavigator = Navigator()

    func presentAppStore(_ appLink: String) {
        Task {
            guard let url = URL(string: appLink) else {
                return
            }
            await openURL(url)
        }
    }

    func onboardingScreen(output: @escaping OnboardingOutputBlock) -> some View {
        let route = OnboardingRoute(navigator: onboardingNavigator,
                                    input: .init(steps: OnboardingFlowStep.allCases),
                                    output: output)
        return onboardingNavigator.initialize(route: route)
    }
}
