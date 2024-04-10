//  
//  OnboardingViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies
import AppStudioModels

enum OnboardingContext: String {
    case onboarding
    case planChange = "plan_change"
}

class OnboardingViewModel: BaseViewModel<OnboardingOutput> {
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.profileCalculationServiceService) private var profileCalculationService
    @Dependency(\.userDataService) private var userDataService

    var router: OnboardingRouter!
    @Published var step: OnboardingFlowStep = .none
    @Published var sex: Sex?
    @Published var activityLevel: ActivityLevel?
    @Published var birthdayDate: Date = .dateWith(day: 1, month: 1, year: 2000)
    @Published var height: CGFloat = 0
    @Published var inchHeight: CGFloat = 0
    @Published var currentWeight: CGFloat = 0
    @Published var desiredWeight: CGFloat = 0
    @Published var heightUnit: HeightUnit = .ft
    @Published var weightUnit: WeightUnit = .lb
    @Published var isMovingForward = true
    @Published var estimatedExpenditureKcal = ""
    @Published var exerciseActivity: ExerciseActivity?
    @Published var activityType: ActivityType?
    @Published var calorieGoal: CalorieGoal?

    @Published var sliderOffset: CGSize = .zero

    @Published var startPoint: CGFloat = 0
    @Published var outsideRange: ClosedRange<Double> = 0...0
    @Published var insideRange: ClosedRange<Double> = 0...0

    @Published var dietType: DietType?
    @Published var proteinLevel: ProteinLevel?

    let steps: [OnboardingFlowStep]
    let context: OnboardingContext

    @Published private var burnPerWeek: WeightMeasure = .init(value: 1200)
    @Published private var succesDate = ""
    @Published private var burnData: OnboardingFastCalorieBurnView.ViewData = .mock
    private var calorieBudget: Double = 0

    init(input: OnboardingInput, output: @escaping OnboardingOutputBlock) {
        steps = input.steps
        context = input.context
        super.init(output: output)
        if input.context == .planChange {
            fillInitialData()
        }
        initialize()
        subscribeToFatBurnChanges()
    }

    var calorieBurnData: OnboardingFastCalorieBurnView.ViewData {
        let sign = calorieGoal == .lose ? "-" : "+"
        return .init(burnPerWeek: sign + WeightMeasure(value: burnPerWeek.value, units: weightUnit).valueWithUnits,
                     averageDailyCalories: burnData.averageDailyCalories,
                     estimatedAchievementDate: succesDate,
                     description: burnData.description,
                     isLessThenMinimum: burnData.isLessThenMinimum)
    }

    var isNextButtonEnabled: Bool {
        switch step {
        case .start:
            true
        case .sex:
            sex != nil
        case .birthday:
            true
        case .height:
            height > 0
        case .currentWeight:
            currentWeight > 0
        case .desiredWeight:
            desiredWeight > 0
        case .activityLevel:
            activityLevel != nil
        case .none:
            false
        case .howOftenDoYouExercise:
            exerciseActivity != nil
        case .whatTrainingYouDoing:
            activityType != nil
        case .estimatedExpenditure:
            true
        case .calorieGoal:
            calorieGoal != nil
        case .dietType:
            dietType != nil
        case .proteinLevel:
            proteinLevel != nil
        case .fastCalorieBurn:
            true
        }
    }

    var canShowNextButton: Bool {
        switch step {
        case .none, .start:
            return false
        default:
            return true
        }
    }

    var canShowPrevButton: Bool {
        guard context == .onboarding else {
            return step != steps.first
        }
        switch step {
        case .none, .start:
            return false
        default:
            return true
        }
    }

    func activityLevelTapped(_ activityLevel: ActivityLevel) {
        self.activityLevel = activityLevel
    }

    func sexTapped(_ sex: Sex) {
        self.sex = sex
    }

    func activityTypeTapped(_ activityType: ActivityType) {
        self.activityType = activityType
    }

    func exerciseActivityTapped(_ exerciseActivity: ExerciseActivity) {
        self.exerciseActivity = exerciseActivity
    }

    func calorieGoalTapped(_ calorieGoal: CalorieGoal) {
        self.calorieGoal = calorieGoal
    }

    func dietTypeTapped(_ dietType: DietType) {
        self.dietType = dietType
    }

    func proteinLevelTapped(_ proteinLevel: ProteinLevel) {
        self.proteinLevel = proteinLevel
    }

    func nextStep() {
        isMovingForward = true
        trackNextStep()

        guard let currentStepIndex = steps.firstIndex(of: step),
              currentStepIndex + 1 < steps.count else {
            finishOnboarding()
            return
        }
        let nextStep = steps[currentStepIndex + 1]

        if nextStep == .estimatedExpenditure {
            let estimatedKcal = profileCalculationService.calculateMaintainEstimatedExpenditure(
                initialData: initialData
            )
            trackerService.track(.tdeeShown(tdee: estimatedKcal))
            estimatedExpenditureKcal = "\(Int(estimatedKcal).formattedCaloriesString)"
        }

        if nextStep == .desiredWeight {
            step = calorieGoal == .maintain ? .dietType : nextStep
            return
        }

        if nextStep == .fastCalorieBurn {
            let ranges = profileCalculationService.calculateSpeedRange(
                initialData: initialData,
                goalData: profileCalculationGoalData
            )

            startPoint = ranges.startingPoint
            outsideRange = ranges.maxRange
            insideRange = ranges.recomendedRange
        }

        step = nextStep
    }

    func prevStep() {
        isMovingForward = false

        guard let currentStepIndex = steps.firstIndex(of: step),
              currentStepIndex - 1 >= 0 else {
            return
        }
        let prevStep = steps[currentStepIndex - 1]

        if prevStep == .fastCalorieBurn, calorieGoal == .maintain {
            step = .calorieGoal
            return
        }
        step = prevStep
    }

    func dismiss() {
        output(.onboardingIsFinished)
    }

    private var initialData: ProfileCalculationInitialData {
        let height: HeightMeasure = heightUnit == .cm ?
            .init(centimeters: self.height) :
            .init(feet: self.height, inches: inchHeight)
        return .init(sex: sex ?? .female,
                     birthday: birthdayDate,
                     height: height,
                     weight: .init(value: currentWeight, units: weightUnit),
                     activityLevel: activityLevel ?? .moderatelyActive,
                     exerciseActivity: exerciseActivity ?? .sessionsPerWeek1to3,
                     activityType: activityType ?? .noActivity
        )
    }

    private var profileCalculationGoalData: ProfileCalculationGoalData {
        .init(targetWeight: .init(value: desiredWeight, units: weightUnit),
              calorieGoal: calorieGoal ?? .lose
        )
    }

    private func subscribeToFatBurnChanges() {
        $startPoint
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, point in
                this.calculateBurnData(point: point)
            }
            .store(in: &cancellables)
    }

    private func calculateBurnData(point: CGFloat) {
        let data = profileCalculationService.calculateDailyCaloriesAndDate(
            initialData: initialData,
            goalData: profileCalculationGoalData,
            weightPerDaySpeed: .init(value: point / 7, units: weightUnit)
        )

        let burnPerWeek = WeightMeasure(value: point,
                                        units: weightUnit)
        let sign = calorieGoal == .lose ? "-" : "+"
        let calorieBurnData = data.convert(
            startPointInRange: insideRange.contains(Double(point)),
            burnPerWeek: "\(sign)\(burnPerWeek)",
            goal: calorieGoal ?? .lose
        )
        if data.calculatedCalorieBudget >= 1200 {
            self.burnPerWeek = burnPerWeek
            succesDate = calorieBurnData.estimatedAchievementDate
            calorieBudget = data.calculatedCalorieBudget
        }
        burnData = calorieBurnData
    }

    private func initialize() {
        Task {
            await MainActor.run { [weak self] in
                if let step = self?.steps.first(where: { $0 != .none }) {
                    self?.step = step
                }
            }
        }
    }

    private func presentPaywall() {
        router.presentPaywall { [weak self] output in
            switch output {
            case .onboardingIsFinished:
                self?.output(.onboardingIsFinished)
            }
        }
    }

    private func presentDailyCalorieBudget(input: DailyCalorieBudgetInput) {
        router.presentDailyCalorie(mode: context == .onboarding ? .onboarding : .userDataChange,
                                   input: input) { [weak self] output in
            guard let self else { return }
            switch output {
            case .startTapped:
                if self.context == .onboarding {
                    self.presentPaywall()
                    return
                }
                self.output(.onboardingIsFinished)
            case .backTapped:
                self.router.dismiss()
            }
        }
    }

    private func finishOnboarding() {
        let calculation = calculation
        setUserProperties(calculation: calculation)
        trackOnboardingFinished(calculation: calculation)
        saveUserData()
        router.presentLoadingView { [weak self] in
            guard let self else { return }
            self.presentDailyCalorieBudget(input: dailyCalorieBudgetInput(calculation: calculation))
        }
    }

    private func dailyCalorieBudgetInput(calculation: ProfileCalculationOutput) -> DailyCalorieBudgetInput {
        DailyCalorieBudgetInput(
            dietData: .init(proteinLevel: proteinLevel ?? .moderate, dietType: dietType ?? .balanced),
            rateSpeed: .init(value: burnPerWeek.value, units: weightUnit),
            initialData: initialData,
            goalData: profileCalculationGoalData,
            calculation: calculation
        )
    }

    private var calculation: ProfileCalculationOutput {
        profileCalculationService.calculate(
            initialData: initialData,
            goalData: profileCalculationGoalData,
            weightPerDaySpeed: .init(value: burnPerWeek.value / 7, units: weightUnit),
            dietData: .init(proteinLevel: proteinLevel ?? .high, dietType: dietType ?? .balanced)
        )
    }

    private func saveUserData() {
        Task {
            try await userDataService.saveData(
                initialData: initialData,
                goalData: profileCalculationGoalData,
                weightPerDaySpeed: .init(value: burnPerWeek.value / 7, units: weightUnit),
                dietData: .init(proteinLevel: proteinLevel ?? .high, dietType: dietType ?? .balanced)
            )
        }
    }

    private func fillInitialData() {
        guard let userData = userDataService.userData,
              let dietData = userDataService.dietData,
              let goalData = userDataService.goalData else {
            return
        }
        sex = userData.sex
        activityLevel = userData.activityLevel
        birthdayDate = userData.birthday
        heightUnit = userData.height.units
        height = heightUnit == .cm ? userData.height.normalizeValue : CGFloat(userData.height.feets.feets)
        inchHeight = heightUnit == .cm ? 0 : CGFloat(userData.height.feets.inches)
        currentWeight = userData.weight.value
        desiredWeight = goalData.targetWeight?.value ?? 0
        weightUnit = userData.weight.units
        exerciseActivity = userData.exerciseActivity
        activityType = userData.activityType
        calorieGoal = goalData.calorieGoal
        dietType = dietData.dietType
        proteinLevel = dietData.proteinLevel
    }
}

private extension OnboardingViewModel {

    func setUserProperties(calculation: ProfileCalculationOutput) {
        userPropertyService.set(userProperties: [
            "sex": sex?.rawValue ?? "",
            "birthday": birthdayDate.description,
            "height": heightUnit == .cm ? height : HeightMeasure(feet: height, inches: inchHeight).normalizeValue,
            "starting_weight": currentWeight,
            "target_weight": desiredWeight,
            "activity_level": activityLevel?.rawValue ?? "",
            "exercise_frequency": exerciseActivity?.analitycsValue ?? "",
            "training_type": activityType?.analyticsValue ?? "",
            "tdee": calculation.totalDailyEnergyExpenditures,
            "goal": calorieGoal?.rawValue ?? "",
            "diet": dietType?.analyticsValue ?? "",
            "protein_level": proteinLevel?.analyticsValue ?? ""
        ])
    }

    func trackOnboardingFinished(calculation: ProfileCalculationOutput) {
        trackerService.track(.onboardingFinished(
            tdee: calculation.totalDailyEnergyExpenditures,
            calorieBudget: calculation.budgetInGramms.calories,
            p: calculation.budgetInGramms.proteins,
            f: calculation.budgetInGramms.fats,
            c: calculation.budgetInGramms.carbohydrates,
            goal: calorieGoal?.rawValue ?? "",
            goalRate: burnPerWeek.value,
            goalUnits: weightUnit.rawValue)
        )
    }

    func trackNextStep() {
        switch step {
        case .start:
            trackerService.track(.tapGetStarted)
        case .sex:
            trackerService.track(.sexAnswered(sex: sex?.rawValue ?? ""))
        case .birthday:
            trackerService.track(.birthdayAnswered(date: birthdayDate.description))
        case .height:
            let height = heightUnit == .cm ? height : HeightMeasure(feet: height, inches: inchHeight).normalizeValue
            trackerService.track(.heightAnswered(height: height, units: heightUnit.rawValue))
        case .currentWeight:
            trackerService.track(.startingWeightAnswered(startingWeight: currentWeight,
                                                         units: weightUnit.rawValue,
                                                         context: context))
        case .desiredWeight:
            trackerService.track(.targetWeightAnswered(targetWeight: desiredWeight,
                                                       units: weightUnit.rawValue,
                                                       context: context))
        case .activityLevel:
            trackerService.track(.activityLevelAnswered(activityLevel: activityLevel?.rawValue ?? "",
                                                        context: context))
        case .none:
            break
        case .howOftenDoYouExercise:
            trackerService.track(.exerciseFrequencyAnswered(excerciseFrequency: exerciseActivity?.analitycsValue ?? "",
                                                            context: context))
        case .whatTrainingYouDoing:
            trackerService.track(.trainingTypeAnswered(trainingType: activityType?.analyticsValue ?? "",
                                                       context: context))
        case .estimatedExpenditure:
            break
        case .calorieGoal:
            trackerService.track(.goalAnswered(goal: calorieGoal?.rawValue ?? "", context: context))
        case .dietType:
            trackerService.track(.preferredDietAnswered(diet: dietType?.analyticsValue ?? "", context: context))
        case .proteinLevel:
            trackerService.track(.proteinLevelAnswered(proteinLevel: proteinLevel?.analyticsValue ?? "",
                                                       context: context))
        case .fastCalorieBurn:
            trackerService.track(.goalRateAnswered(goalRate: burnPerWeek.value,
                                                   units: weightUnit.rawValue,
                                                   achievementDate: burnData.estimatedAchievementDate,
                                                   calorieBudget: calorieBudget,
                                                   context: context))
        }
    }
}
