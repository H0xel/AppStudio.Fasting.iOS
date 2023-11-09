//  
//  ChooseFastingPlanViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

class ChooseFastingPlanViewModel: BaseViewModel<ChooseFastingPlanOutput> {
    var router: ChooseFastingPlanRouter!
    let context: ChooseFastingPlanInput.Context

    let plans: [FastViewPlan] = [.init(plan: .regular), .init(plan: .beginner), .init(plan: .expert)]
    @Published var index = 0

    init(input: ChooseFastingPlanInput, output: @escaping ChooseFastingPlanOutputBlock) {
        context = input.context
        super.init(output: output)
    }

    func choosePlanTapped() {
        let plan = plans[index].plan
        router.showSetupFastingScreen(context: .init(context), plan: plan) { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.output(.onboardingIsFinished)
            }
        }
    }

    func backButtonTapped() {
        router.dismiss()
    }
}

struct FastViewPlan: Hashable {
    let plan: FastingPlan
}
