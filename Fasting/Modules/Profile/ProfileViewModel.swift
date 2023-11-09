//  
//  ProfileViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Dependencies

class ProfileViewModel: BaseViewModel<ProfileOutput> {
    @Dependency(\.fastingParametersService) private var fastingParametersService

    var router: ProfileRouter!
    @Published var plan: FastingPlan = .beginner

    init(input: ProfileInput, output: @escaping ProfileOutputBlock) {
        super.init(output: output)
        subscribeToFastingPlan()
    }

    func changePlan() {
        router.presentChooseFastingPlan()
    }

    func presentTermsOfUse() {
        guard let url = URL(string: GlobalConstants.termsOfUse) else {
            return
        }
        router.open(url: url)
    }

    func preesentPrivacyPolicy() {
        guard let url = URL(string: GlobalConstants.privacyPolicy) else {
            return
        }
        router.open(url: url)
    }

    func contactSupport() {
        router.presentSupport()
    }

    private func subscribeToFastingPlan() {
        fastingParametersService.fastingIntervalPublisher
            .map(\.plan)
            .assign(to: &$plan)
    }
}
