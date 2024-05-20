//  
//  OnboardingRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies
import AppStudioUI

class OnboardingRouter: BaseRouter {

    static func route(navigator: Navigator,
                      input: OnboardingInput,
                      output: @escaping OnboardingOutputBlock) -> Route {
        OnboardingRoute(navigator: navigator, input: input, output: output)
    }

    func presentPersonalizedPaywall(input: PersonalizedPaywallInput, output: @escaping ChooseFastingPlanOutputBlock) {
        let route = PersonalizedPaywallRoute(navigator: navigator, input: input) { [weak self] paywallOutput in

            switch paywallOutput {
            case .close, .subscribed:
                self?.pushChooseFastingScreen(output: output)
            case let .showDiscountPaywall(input):
                self?.navigator.dismiss()
                self?.presentDiscountPaywall(input: input, output: output)
            }
        }
        present(route: route)
    }

    func presentPaywall(output: @escaping ChooseFastingPlanOutputBlock) {
        let route = PaywallRoute(navigator: navigator, input: .onboarding) { [weak self] paywallOutput in

            switch paywallOutput {
            case .close, .subscribed:
                self?.pushChooseFastingScreen(output: output)
            case let .showDiscountPaywall(input):
                self?.navigator.dismiss()
                self?.presentDiscountPaywall(input: input, output: output)
            case .switchProgressView(let isPresented):
                if isPresented {
                    self?.present(banner: DimmedProgressBanner())
                } else {
                    self?.dismissBanner()
                }
            }
        }
        present(route: route)
    }

    func presentDiscountPaywall(input: DiscountPaywallInput, output: @escaping ChooseFastingPlanOutputBlock) {
        let route = DiscountPaywallRoute(navigator: navigator, input: input) { [weak self] paywallOutput in
            switch paywallOutput {
            case .close, .subscribe:
                self?.pushChooseFastingScreen(output: output)
            case .switchProgress:
                break
            }
        }
        present(route: route)
    }

    func pushChooseFastingScreen(output: @escaping ChooseFastingPlanOutputBlock) {
        let route = ChooseFastingPlanRoute(navigator: navigator, input: .init(context: .onboarding), output: output)
        push(route: route)
    }

    func presentLoadingView(completion: @escaping () -> Void) {
        let route = OnboardingLoadingViewRoute(navigator: navigator) { _ in
            self.navigator.dismiss()
            completion()
        }
        push(route: route)
    }
}
