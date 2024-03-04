//  
//  OnboardingLoadingViewViewModel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 07.12.2023.
//

import AppStudioNavigation
import AppStudioUI
import Combine
import Foundation

class OnboardingLoadingViewViewModel: BaseViewModel<OnboardingLoadingViewOutput> {
    var router: OnboardingLoadingViewRouter!
    @Published private var data: OnboardingCalculationProccessData = .calculateData(interval: 0)
    private var isFinished = false

    var title: String {
        data.phase.title
    }

    var description: String {
        data.phase.description
    }

    var angle: CGFloat {
        data.angle
    }

    var progress: CGFloat {
        data.progress
    }

    func updateOnboardingCalculationProccessData(interval: CGFloat) {
        self.data = .calculateData(interval: interval)
        if data.progress > 1.0 && !isFinished {
            isFinished = true
            finishProccess()
        }
    }

    private func finishProccess() {
        output(.finished)
    }
}
