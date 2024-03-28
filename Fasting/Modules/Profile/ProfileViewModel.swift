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
    @Dependency(\.trackerService) private var trackerService

    var router: ProfileRouter!
    @Published var plan: FastingPlan = .beginner

    init(input: ProfileInput, output: @escaping ProfileOutputBlock) {
        super.init(output: output)
        subscribeToFastingPlan()
    }

    func changePlan() {
        router.presentChooseFastingPlan()
        trackChangeTapped(currentSchedule: plan.description)
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
        trackTapSupport()
    }

    func close() {
        router.dismiss()
    }

    private func subscribeToFastingPlan() {
        fastingParametersService.fastingIntervalPublisher
            .map(\.plan)
            .assign(to: &$plan)
    }
}

private extension ProfileViewModel {
    func trackChangeTapped(currentSchedule: String) {
        trackerService.track(.tapChangeSchedule(currentSchedule: currentSchedule, context: .profile))
    }

    func trackTapSupport() {
        trackerService.track(.tapSupport)
    }
}
