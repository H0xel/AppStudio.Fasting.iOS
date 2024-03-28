//  
//  SetupFastingRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

class SetupFastingRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: SetupFastingInput,
                      output: @escaping SetupFastingOutputBlock) -> Route {
        SetupFastingRoute(navigator: navigator, input: input, output: output)
    }

    func pushNotificationOnboarding(output: @escaping NotificationOnboardingOutputBlock) {
        let route = NotificationOnboardingRoute(navigator: navigator, input: .init(), output: output)
        push(route: route)
    }

    func presentChooseFasting(context: ChooseFastingPlanInput.Context) {
        let route = ChooseFastingPlanRoute(navigator: navigator, input: .init(context: context)) { event in
            switch event {
            case .onboardingIsFinished: break
            }
        }
        present(route: route)
    }
}
