//  
//  FastingRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation

class FastingRouter: BaseRouter {
    func presentStartFastingDialog(initialDate: Date, maxDate: Date, onSave: @escaping (Date) -> Void) {
        let input = StartFastingInput.startFasting(initialDate: initialDate,
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

    func presentSetupFasting(plan: FastingPlan) {
        let route = SetupFastingRoute(navigator: navigator, input: .init(plan: plan, context: .mainScreen)) { event in
            switch event {
            case .onboardingIsFinished: break
            }
        }

        present(route: route)
    }
}
