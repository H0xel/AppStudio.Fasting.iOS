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
import HealthOverview
import AppStudioServices

class RootRouter: BaseRouter {
    @Dependency(\.openURL) private var openURL

    let fastingNavigator = Navigator()
    let healthOverviewNavigator = Navigator()
    private let paywallNavigator = Navigator()
    private let coachNavigator = Navigator()
    private let onboardingNavigator = Navigator()
    private let healthProgressNavigator = Navigator()

    override init(navigator: Navigator) {
        super.init(navigator: navigator)
    }

    var fastingScreen: some View {
        fastingNavigator.rootRoute?.view
    }

    func healthProgressScreen(
        isMonetizationExpAvailablePublisher: AnyPublisher<Bool, Never>,
        inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
        output: @escaping HealthProgressOutputBlock
    ) -> some View {
        let route = FastingHealthProgressRoute(navigator: healthProgressNavigator, 
                                               isMonetizationExpAvailablePublisher: isMonetizationExpAvailablePublisher,
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

    func healthOverviewScreen(input: HealthOverviewInput,
                              output: @escaping HealthOverviewOutputBlock) -> some View {
        let route = HealthOverviewRoute(navigator: healthOverviewNavigator,
                                        input: input,
                                        output: output)
        return healthOverviewNavigator.initialize(route: route)
    }

    func coachScreen(isMonetizationExpAvailable: AnyPublisher<Bool, Never>,
                     nextMessagePublisher: AnyPublisher<String, Never>) -> some View {
        let route = CoachRoute(navigator: coachNavigator,
                               input: .init(constants: .fastingConstants,
                                            suggestionTypes: [.general, .fasting],
                                            nextMessagePublisher: nextMessagePublisher,
                                            isMonetizationExpAvailable: isMonetizationExpAvailable),
                               output: { [weak self] output in
            switch output {
            case .presentMultiplePaywall:
                self?.presentMultipleProductPaywall(context: .nova)
            case .focusChanged: break
            }
        })
        return coachNavigator.initialize(route: route)
    }

    func presentDiscountPaywall(tab: AppTab, info: DiscountPaywallInfo) {

        var navigator: Navigator {
            switch tab {
            case .fasting:
                return fastingNavigator
            case .coach:
                return coachNavigator
            case .paywall:
                return paywallNavigator
            case .healthProgress:
                return healthProgressNavigator
            case .daily:
                return healthOverviewNavigator
            }
        }

        let route = DiscountPaywallRoute(navigator: navigator,
                                         input: .init(context: .discountPush, paywallInfo: info),
                                         output: { output in
            switch output {
            case .close, .subscribe: navigator.dismiss()
            case .switchProgress: break
            }
        })

        navigator.present(route: route)
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

    func presentProfile() {
        let route = ProfileRoute(navigator: healthOverviewNavigator,
                                 input: .init(),
                                 output: { _ in })
        healthOverviewNavigator.present(route: route)
    }

    func presentMultipleProductPaywall(context: PaywallContext) {

        var navigator: Navigator

        switch context {
        case .daily, .popup:
            navigator = healthOverviewNavigator
        case .fastingStages:
            navigator = fastingNavigator
        case .nova:
            navigator = coachNavigator
        case .progress:
            navigator = healthProgressNavigator
        default:
            navigator = self.navigator
        }

        let route = MultiplePaywallRoute(navigator: navigator,
                                         input: .init(paywallContext: context),
                                         output: { output in
            switch output {
            case .close, .subscribed:
                navigator.dismiss()
            }
        })
        navigator.present(route: route)
    }

    func presentSuccess(on tab: AppTab, input: SuccessInput, output: @escaping SuccessOutputBlock) {
        let route = SuccessRoute(navigator: navigator(for: tab),
                                 input: input,
                                 output: output)
        navigator(for: tab).present(route: route)
    }

    func presentProgressView(for tab: AppTab, isOnboarding: Bool) {
        var navigator: Navigator {
            if isOnboarding {
                return onboardingNavigator
            }
            return self.navigator(for: tab)
        }
        navigator.present(banner: DimmedProgressBanner())
    }

    func dismissBanner(for tab: AppTab, isOnboarding: Bool) {
        var navigator: Navigator {
            if isOnboarding {
                return onboardingNavigator
            }
            return self.navigator(for: tab)
        }
        navigator.dismissBanner()
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }

    private func navigator(for tab: AppTab) -> Navigator {
        switch tab {
        case .fasting:
            fastingNavigator
        case .coach:
            coachNavigator
        case .paywall:
            paywallNavigator
        case .healthProgress:
            healthProgressNavigator
        case .daily:
            healthOverviewNavigator
        }
    }
}
