//  
//  ChooseFastingPlanRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

class ChooseFastingPlanRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: ChooseFastingPlanInput,
                      output: @escaping ChooseFastingPlanOutputBlock) -> Route {
        ChooseFastingPlanRoute(navigator: navigator, input: input, output: output)
    }

    func showSetupFastingScreen(
        context: SetupFastingInput.Context,
        plan: FastingPlan,
        output: @escaping SetupFastingOutputBlock) {

            let route = SetupFastingRoute(
                navigator: navigator,
                input: .init(plan: plan, context: context),
                output: output
            )

            if context == .onboarding {
                push(route: route)
            }

            if context == .profile || context == .mainScreen {
                present(route: route)
            }
    }
}
