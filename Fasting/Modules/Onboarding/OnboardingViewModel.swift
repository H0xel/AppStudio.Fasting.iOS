//  
//  OnboardingViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Dependencies

class OnboardingViewModel: BaseViewModel<OnboardingOutput> {
    @Dependency(\.trackerService) private var trackerService
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
        trackTapGetStarted()
    }
}

private extension OnboardingViewModel {
    func trackTapGetStarted() {
        trackerService.track(.tapGetStarted)
    }
}
