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
                self?.pushChooseFastingScreen(context: .onboarding, output: output)
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
                self?.pushChooseFastingScreen(context: .onboarding, output: output)
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
                self?.pushChooseFastingScreen(context: .onboarding, output: output)
            case .switchProgress:
                break
            }
        }
        present(route: route)
    }

    func pushChooseFastingScreen(context: ChooseFastingPlanInput.Context, output: @escaping ChooseFastingPlanOutputBlock) {
        let route = ChooseFastingPlanRoute(navigator: navigator, input: .init(context: context), output: output)
        push(route: route)
    }

    func presentLoadingView(completion: @escaping () -> Void) {
        let route = OnboardingLoadingViewRoute(navigator: navigator) { _ in
            self.navigator.dismiss()
            completion()
        }
        push(route: route)
    }

    func pushW2WLoginScreen(output: @escaping ChooseFastingPlanOutputBlock) {
        let route = W2WLoginRoute(navigator: navigator, input: .init(context: .onboarding)) { [weak self] outputEvent in
            switch outputEvent {
            case .close:
                self?.navigator.dismiss()
            case .userSaved:
                self?.pushChooseFastingScreen(context: .w2wOnboarding, output: output)
            }
        }
        push(route: route)
    }

    func open(url: URL) {
        let route = SafariRoute(url: url) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }
}
