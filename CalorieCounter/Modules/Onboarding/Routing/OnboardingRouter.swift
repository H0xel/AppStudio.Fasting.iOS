//
//  OnboardingRouter.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies
import AppStudioUI

class OnboardingRouter: BaseRouter {
    @Dependency(\.paywallService) private var paywallService

    static func route(navigator: Navigator,
                      input: OnboardingInput,
                      output: @escaping OnboardingOutputBlock) -> Route {
        OnboardingRoute(navigator: navigator, input: input, output: output)
    }

    func presentPersonalizedPaywall(
        input: PersonalizedPaywallInput,
        output: @escaping NotificationOnboardingOutputBlock
    ) {
        let route = PersonalizedPaywallRoute(navigator: navigator, input: input) { _ in
            output(.onboardingIsFinished)
        }
        present(route: route)
    }

    func presentPaywall(output: @escaping NotificationOnboardingOutputBlock) {
        let route = PaywallRoute(navigator: navigator, input: .onboarding) { [weak self] paywallOutput in
            switch paywallOutput {
            case .close, .subscribed:
                output(.onboardingIsFinished)
            case .showDiscountPaywall(let input):
                self?.navigator.dismiss()
                self?.presentDiscountPaywall(input: input, output: output)
            }
        }
        present(route: route)
    }

    func presentDiscountPaywall(input: DiscountPaywallInput, output: @escaping NotificationOnboardingOutputBlock) {
        let route = DiscountPaywallRoute(navigator: navigator, input: input) { _ in
            output(.onboardingIsFinished)
        }
        present(route: route)
    }

    func presentDailyCalorie(mode: DailyCalorieBudgetScreenMode,
                             input: DailyCalorieBudgetInput,
                             output: @escaping DailyCalorieBudgetOutputBlock) {
        let route = DailyCalorieBudgetRoute(navigator: navigator,
                                            mode: mode,
                                            input: input,
                                            output: output)
        present(route: route)
    }

    func pushNotificationOnboarding(output: @escaping NotificationOnboardingOutputBlock) {
        let route = NotificationOnboardingRoute(navigator: navigator, input: .init(), output: output)
        push(route: route)
    }

    func presentLoadingView(completion: @escaping () -> Void) {
        let route = OnboardingLoadingViewRoute(navigator: navigator) { [weak self] _ in
            self?.dismiss()
            completion()
        }
        push(route: route)
    }
}
