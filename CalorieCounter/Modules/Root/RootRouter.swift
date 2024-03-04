//  
//  RootRouter.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class RootRouter: BaseRouter {
    @Dependency(\.paywallService) private var paywallService
    @Dependency(\.openURL) private var openURL
    let onboardingNavigator = Navigator()

    lazy var tabBarScreen: some View = {
        TabBarRoute(navigator: .init(), input: .init(), output: { _ in }).view
    }()

    func onboardingScreen(output: @escaping OnboardingOutputBlock) -> some View {
        let route = OnboardingRoute(navigator: onboardingNavigator,
                                    input: .init(context: .onboarding, steps: OnboardingFlowStep.allCases),
                                    output: output)
        return onboardingNavigator.initialize(route: route)
    }

    func presentPaywall() {
        Task {
            await paywallService.presentPaywallIfNeeded(paywallContext: .onboarding, router: self)
        }
    }

    func presentAppStore(_ appLink: String) {
        Task {
            guard let url = URL(string: appLink) else {
                return
            }
            await openURL(url)
        }
    }

    func presentSupport() {
        guard EmailRoute.canPresent else {
            sendEmailWithOpenUrl()
            return
        }
        let subject = NSLocalizedString("ProfileScreen.supportEmailSubject", comment: "")
        let route = EmailRoute(recipient: GlobalConstants.contactEmail, subject: subject) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }
}
