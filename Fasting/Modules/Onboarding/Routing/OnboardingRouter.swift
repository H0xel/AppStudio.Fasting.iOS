//  
//  OnboardingRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class OnboardingRouter: BaseRouter {
    @Dependency(\.paywallService) private var paywallService

    static func route(navigator: Navigator,
                      input: OnboardingInput,
                      output: @escaping OnboardingOutputBlock) -> Route {
        OnboardingRoute(navigator: navigator, input: input, output: output)
    }

    func presentPaywall(output: @escaping ChooseFastingPlanOutputBlock) {
        let route = PaywallRoute(navigator: navigator, input: .onboarding) { [weak self] _ in
            self?.pushChooseFastingScreen(output: output)
        }
        present(route: route)
    }

    private func pushChooseFastingScreen(output: @escaping ChooseFastingPlanOutputBlock) {
        let route = ChooseFastingPlanRoute(navigator: navigator, input: .init(context: .onboarding), output: output)
        push(route: route)
    }
}
