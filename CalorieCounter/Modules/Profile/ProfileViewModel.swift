//  
//  ProfileViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Dependencies

class ProfileViewModel: BaseViewModel<ProfileOutput> {

    @Dependency(\.userDataService) private var userDataService
    @Dependency(\.profileCalculationServiceService) private var profileCalculationServiceService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService

    var router: ProfileRouter!
    @Published private var userData: ProfileCalculationInitialData?
    @Published private var weightPerDayChangeSpeed: WeightMeasure?
    @Published private var goalData: ProfileCalculationGoalData?
    @Published private var nutritionProfile: NutritionProfile = .empty

    init(input: ProfileInput, output: @escaping ProfileOutputBlock) {
        super.init(output: output)
        loadData()
    }

    var sex: Sex {
        userData?.sex ?? .female
    }

    var birthday: String {
        userData?.birthday.currentLocaleFormatted(with: "MMdyyyy") ?? ""
    }

    var height: String {
        userData?.height.valueWithUnits ?? ""
    }

    var weeklyWeightChange: String {
        guard let speed = weightPerDayChangeSpeed else { return "" }
        let weeklySpeed = WeightMeasure(value: speed.value * 7, units: speed.units)
        let sign = goal == .lose ? "-" : "+"
        return "\(sign)\(weeklySpeed.valueWithUnits)"
    }

    var goal: CalorieGoal {
        goalData?.calorieGoal ?? .lose
    }

    var targetWeight: WeightMeasure {
        goalData?.targetWeight ?? .init(value: 0)
    }

    var caloriesGoal: String {
        let calories = NSLocalizedString("MealTypeView.calories", comment: "kcal")
        return "\(nutritionProfile.calories.formattedCaloriesString) \(calories)"
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
        trackerService.track(.tapSupport)
        router.presentSupport()
    }

    func changeSex() {
        trackerService.track(.tapChangeSex)
        switchTabBar(isHidden: true)
        router.presentChangeSex(currentSex: sex) { [weak self] in
            self?.switchTabBar(isHidden: false)
        } onSave: { [weak self] newSex in
            self?.switchTabBar(isHidden: false)
            self?.updateSex(newSex)
        }
    }

    func changeBirthday() {
        trackerService.track(.tapChangeBirthdayDate)
        guard let date = userData?.birthday else { return }
        switchTabBar(isHidden: true)
        router.presentChangeBirthday(currentBirthday: date) { [weak self] in
            self?.output(.switchTabBar(isHidden: false))
        } onSave: { [weak self] date in
            self?.switchTabBar(isHidden: false)
            self?.updateBirthday(date)
        }
    }

    func changeHeight() {
        trackerService.track(.tapChangeHeight)
        guard let height = userData?.height else { return }
        switchTabBar(isHidden: true)
        router.presentChangeHeight(currentHeight: height) { [weak self] in
            self?.output(.switchTabBar(isHidden: false))
        } onSave: { [weak self] height in
            self?.switchTabBar(isHidden: false)
            self?.updateHeight(height)
        }
    }

    func changeGoal() {
        trackerService.track(.tapChangePlan)
        let steps: [OnboardingFlowStep] = [
            .calorieGoal,
            .currentWeight,
            .desiredWeight,
            .activityLevel,
            .howOftenDoYouExercise,
            .whatTrainingYouDoing,
            .fastCalorieBurn,
            .dietType,
            .proteinLevel
        ]

        switchTabBar(isHidden: true)
        router.presentChageGoal(steps: steps) { [weak self] output in
            switch output {
            case .onboardingIsFinished:
                self?.router.popToRoot()
                self?.switchTabBar(isHidden: false)
                self?.output(.updateProfile)
                DispatchQueue.main.async {
                    self?.loadData()
                }
            }
        }
    }

    func presentInfo() {
        guard let userData,
              let goalData,
              let weightPerDayChangeSpeed,
              let dietData = userDataService.dietData else {
            return
        }

        let calculation = profileCalculationServiceService.calculate(initialData: userData,
                                                                     goalData: goalData,
                                                                     weightPerDaySpeed: weightPerDayChangeSpeed,
                                                                     dietData: dietData)
        let input = DailyCalorieBudgetInput(
            dietData: dietData,
            rateSpeed: .init(value: weightPerDayChangeSpeed.value * 7,
                             units: weightPerDayChangeSpeed.units),
            initialData: userData,
            goalData: goalData,
            calculation: calculation
        )
        router.presentDailyCalorie(input: input) { [weak self] output in
            self?.router.dismiss()
            switch output {
            case .backTapped:
                break
            case .startTapped:
                break
            }
        }
    }

    func trackPresentPlanDetails() {
        trackerService.track(.tapPlanDetails)
    }

    private func loadData() {
        userData = userDataService.userData
        weightPerDayChangeSpeed = userDataService.weightPerDaySpeed
        goalData = userDataService.goalData
        updateProfile(date: .now)
    }

    private func updateProfile(date: Date) {
        Task { [weak self] in
            guard let self else { return }
            let profile = try await self.userDataService.nutritionProfile(dayDate: date)
            await MainActor.run {
                self.nutritionProfile = profile
            }
        }
    }

    private func updateBirthday(_ newBirthday: Date) {
        userPropertyService.set(userProperties: ["birthday": newBirthday.description])
        trackerService.track(.birthdayChanged)
        guard let userData else { return }
        let data = userData.updated(birthday: newBirthday)
        updateUserDataAndPresentInfo(data)
    }

    private func updateSex(_ newSex: Sex) {
        userPropertyService.set(userProperties: ["sex": newSex.rawValue])
        trackerService.track(.sexChanged)
        guard let userData else { return }
        let data = userData.updated(sex: newSex)
        updateUserDataAndPresentInfo(data)
    }

    private func updateHeight(_ newHeight: HeightMeasure) {
        userPropertyService.set(userProperties: ["height": newHeight.normalizeValue])
        trackerService.track(.heightChanged)
        guard let userData else { return }
        let data = userData.updated(height: newHeight)
        updateUserDataAndPresentInfo(data)
    }

    private func updateUserDataAndPresentInfo(_ data: ProfileCalculationInitialData) {
        guard let goalData,
              let weightPerDayChangeSpeed,
              let dietData = userDataService.dietData else {
            return
        }
        Task { [weak self] in
            guard let self else { return }
            try await userDataService.saveData(initialData: data,
                                               goalData: goalData,
                                               weightPerDaySpeed: weightPerDayChangeSpeed,
                                               dietData: dietData)
            await MainActor.run {
                self.loadData()
                self.presentInfo()
            }
        }
    }

    private func switchTabBar(isHidden: Bool) {
        output(.switchTabBar(isHidden: isHidden))
    }
}
