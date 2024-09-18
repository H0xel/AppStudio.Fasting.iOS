//  
//  OnboardingRouter.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 12.09.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

class OnboardingRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: OnboardingInput,
                      output: @escaping OnboardingOutputBlock) -> Route {
        OnboardingRoute(navigator: navigator, input: input, output: output)
    }

    func presentLoadingView(completion: @escaping () -> Void) {
        let route = OnboardingLoadingViewRoute(navigator: navigator) { [weak self] _ in
            self?.dismiss()
            completion()
        }
        push(route: route)
    }

    func presentPeriodOnboardingDetails(output: @escaping PeriodOnboardingDetailsOutputBlock) {
        let route = PeriodOnboardingDetailsRoute(navigator: navigator, input: .init(), output: output)
        present(route: route)
    }

    func presentPaywall(completion: @escaping () -> Void) {
        let route = PaywallRoute(navigator: navigator, input: .onboarding) { paywallOutput in
            switch paywallOutput {
            case .close, .subscribed:
                completion()
            }
        }
        present(route: route)
    }
}
