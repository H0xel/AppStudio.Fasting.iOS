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
import AppStudioModels
import AppStudioServices

class ProfileViewModel: BaseViewModel<ProfileOutput> {
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.intercomService) private var intercomService
    @Published private var userData: OnboardingData?

    var router: ProfileRouter!
    @Published var plan: FastingPlan = .beginner

    init(input: ProfileInput, output: @escaping ProfileOutputBlock) {
        super.init(output: output)
        subscribeToFastingPlan()
        loadData()
    }

    var sex: Sex {
        userData?.sex ?? .female
    }

    var birthday: Date? {
        userData?.birthdayDate
    }

    var height: HeightMeasure {
        userData?.height ?? .init(centimeters: 180)
    }

    func changeSex() {
        trackerService.track(.tapChangeSex)
        router.presentChangeSex(currentSex: sex) { [weak self] newSex in
            self?.updateSex(newSex)
        }
    }

    func changeBirthday() {
        trackerService.track(.tapChangeBirthdayDate)
        router.presentChangeBirthday(currentBirthday: birthday ?? .now) { [weak self] date in
            self?.updateBirthday(date)
        }
    }

    func changeHeight() {
        trackerService.track(.tapChangeHeight)
        router.presentChangeHeight(currentHeight: height) { [weak self] height in
            self?.updateHeight(height)
        }
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
        intercomService.presentIntercom()
            .sink { _ in }
            .store(in: &cancellables)
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

    private func loadData() {
        userData = onboardingService.data
    }

    private func updateSex(_ newSex: Sex) {
        userPropertyService.set(userProperties: ["sex": newSex.rawValue])
        trackerService.track(.sexChanged)
        guard let userData = userData?.updated(sex: newSex) else { return }
        onboardingService.save(data: userData)
        self.userData = userData
    }

    private func updateBirthday(_ newBirthday: Date) {
        userPropertyService.set(userProperties: ["birthday": newBirthday.description])
        trackerService.track(.birthdayChanged)
        guard let userData = userData?.updated(birthdayDate: newBirthday) else { return }
        onboardingService.save(data: userData)
        self.userData = userData
    }

    private func updateHeight(_ newHeight: HeightMeasure) {
        userPropertyService.set(userProperties: ["height": newHeight.normalizeValue])
        trackerService.track(.heightChanged)
        guard let userData = userData?.updated(height: newHeight) else { return }
        onboardingService.save(data: userData)
        self.userData = userData
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
