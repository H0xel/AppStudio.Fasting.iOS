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

    var isWidgetPresented = true
    private let fastingWidgetNavigator: Navigator

    init(navigator: Navigator, fastingWidgetNavigator: Navigator) {
        self.fastingWidgetNavigator = fastingWidgetNavigator
        super.init(navigator: navigator)
    }

    func dismiss() {
        currentNavigator.dismiss()
    }

    func dismiss() async {
        await currentNavigator.dismiss()
    }

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

        let route = StartFastingRoute(navigator: currentNavigator, input: input) { event in
            switch event {
            case .save(let date):
                onSave(date)
            }
        }
        currentNavigator.present(sheet: route, detents: [.height(484)], showIndicator: false)
    }

    func presentSuccess(plan: FastingPlan, startDate: Date, endDate: Date, output: @escaping SuccessOutputBlock) {
        let route = SuccessRoute(navigator: currentNavigator,
                                 input: .init(plan: plan, startDate: startDate, endDate: endDate, isEmpty: false),
                                 output: output)
        currentNavigator.present(route: route)
    }

    func presentEndFastingEarly(output: @escaping EndFastingEarlyOutputBlock) {
        let route = EndFastingEarlyRoute(navigator: currentNavigator, input: .init(), output: output)
        currentNavigator.present(sheet: route, detents: [.height(549)], showIndicator: false)
    }

    func presentPaywall(output: @escaping ViewOutput<PaywallScreenOutput>) {
        let route = PaywallRoute(navigator: currentNavigator,
                                 input: .freeUsageLimit,
                                 output: output)
        currentNavigator.present(route: route)
    }

    func presentSetupFasting(plan: FastingPlan, context: SetupFastingInput.Context) {
        let route = SetupFastingRoute(
            navigator: currentNavigator,
            input: .init(plan: plan, context: context)
        ) { event in
            switch event {
            case .onboardingIsFinished: break
            }
        }
        currentNavigator.present(route: route)
    }

    func presentInActiveFastingArticle(_ stage: FastingInActiveArticle) {
        let route = InActiveFastingArticleRoute(
            navigator: currentNavigator,
            input: .init(fastingInActiveStage: stage)
        ) { _ in }
        currentNavigator.present(route: route)
    }

    func presentArticle(isMonetizationExpAvailable: Bool, for stage: FastingStage) {
        let route = FastingPhaseRoute(navigator: currentNavigator, input: .init(
            isMonetizationExpAvailable: isMonetizationExpAvailable,
            stage: stage), output: { _ in })
        currentNavigator.present(route: route)
    }

    private var currentNavigator: Navigator {
        isWidgetPresented ? fastingWidgetNavigator : navigator
    }
}
