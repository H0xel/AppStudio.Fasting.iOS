//
//  FastingRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class FastingRouter: BaseRouter {
    func presentStartFastingDialog(isActiveState: Bool,
                                   initialDate: Date,
                                   minDate: Date,
                                   maxDate: Date,
                                   onSave: @escaping (Date) -> Void) {
        let input = StartFastingInput.startFasting(context: .fastingScreen,
                                                   isActiveState: isActiveState,
                                                   initialDate: initialDate,
                                                   minDate: minDate,
                                                   maxDate: maxDate,
                                                   components: [.hourAndMinute, .date])

        let route = StartFastingRoute(navigator: navigator, input: input) { event in
            switch event {
            case .save(let date):
                onSave(date)
            }
        }
        present(sheet: route, detents: [.height(484)])
    }

    func presentSuccess(plan: FastingPlan, startDate: Date, endDate: Date, output: @escaping SuccessOutputBlock) {
        let route = SuccessRoute(navigator: navigator,
                                 input: .init(plan: plan, startDate: startDate, endDate: endDate),
                                 output: output)
        present(route: route)
    }

    func presentEndFastingEarly(output: @escaping EndFastingEarlyOutputBlock) {
        let route = EndFastingEarlyRoute(navigator: navigator, input: .init(), output: output)
        present(sheet: route, detents: [.height(549)])
    }

    func presentPaywall(output: @escaping ViewOutput<PaywallScreenOutput>) {
        let route = PaywallRoute(navigator: navigator,
                                 input: .freeUsageLimit,
                                 output: output)
        present(route: route)
    }

    func presentSetupFasting(plan: FastingPlan) {
        let route = SetupFastingRoute(navigator: navigator, input: .init(plan: plan, context: .mainScreen)) { event in
            switch event {
            case .onboardingIsFinished: break
            }
        }
        present(route: route)
    }

    func presentInActiveFastingArticle(_ stage: FastingInActiveArticle) {
        let route = InActiveFastingArticleRoute(navigator: navigator,
                                                input: .init(fastingInActiveStage: stage)) { _ in }
        present(route: route)
    }

    func presentArticle(for stage: FastingStage) {
        let route = FastingPhaseRoute(navigator: navigator, input: .init(stage: stage), output: { _ in })
        present(route: route)
    }
}
