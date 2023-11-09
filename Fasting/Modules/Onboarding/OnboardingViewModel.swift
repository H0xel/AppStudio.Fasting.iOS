//  
//  OnboardingViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI

class OnboardingViewModel: BaseViewModel<OnboardingOutput> {
    var router: OnboardingRouter!

    init(input: OnboardingInput, output: @escaping OnboardingOutputBlock) {
        super.init(output: output)
    }

    func getStartedTapped() {
        router.presentPaywall { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.output(.onboardingIsFinished)
            }
        }
    }
}
