//  
//  RootRouter.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies
import AICoach
import HealthProgress
import Combine

class RootRouter: BaseRouter {
    @Dependency(\.paywallService) private var paywallService
    @Dependency(\.openURL) private var openURL

    private let fastingNavigator = Navigator()
    private let profileNavigator = Navigator()
    private let paywallNavigator = Navigator()
    private let coachNavigator = Navigator()
    private let onboardingNavigator = Navigator()
    private let healthProgressNavigator = Navigator()

    override init(navigator: Navigator) {
        super.init(navigator: navigator)
    }

    func fastingScreen(output: @escaping FastingOutputBlock) -> some View {
        let route = FastingRoute(navigator: fastingNavigator,
                                 input: .init(),
                                 output: output)
        return fastingNavigator.initialize(route: route)
    }

    lazy var profileScreen: some View = {
        let route = ProfileRoute(
            navigator: profileNavigator,
            input: .init(),
            output: { _ in }
        )
        return profileNavigator.initialize(route: route)
    }()

    func healthProgressScreen(
        inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
        output: @escaping HealthProgressOutputBlock
    ) -> some View {
        let route = FastingHealthProgressRoute(navigator: healthProgressNavigator,
                                               inputPublisher: inputPublisher,
                                               output: output)
        return healthProgressNavigator.initialize(route: route)
    }

    func paywallScreen(onProgress: @escaping (Bool) -> Void) -> some View {
        let route = PaywallRoute(navigator: paywallNavigator, input: .fromSettings) { output in
            switch output {
            case .close, .subscribed, .showDiscountPaywall:
                break
            case .switchProgressView(let isPresented):
                onProgress(isPresented)
            }
        }
        return paywallNavigator.initialize(route: route)
    }

    func coachScreen(nextMessagePublisher: AnyPublisher<String, Never>) -> some View {
        let route = CoachRoute(navigator: coachNavigator,
                               input: .init(constants: .fastingConstants, nextMessagePublisher: nextMessagePublisher),
                               output: { _ in })
        return coachNavigator.initialize(route: route)
    }

    func presentPaywall() {
        Task {
            await paywallService.presentPaywallIfNeeded(paywallContext: .onboarding, router: self)
        }
    }

    func onboardingScreen(output: @escaping OnboardingOutputBlock) -> some View {
        let route = OnboardingRoute(navigator: onboardingNavigator, input: .init(), output: output)
        return onboardingNavigator.initialize(route: route)
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
