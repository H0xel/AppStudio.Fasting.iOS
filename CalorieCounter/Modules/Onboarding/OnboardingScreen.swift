//
//  OnboardingScreen.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioStyles
import AppStudioModels

struct OnboardingScreen: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            currentView
                .frame(maxWidth: .infinity)
                .padding(.horizontal, viewHorizontalPadding)
                .transition(transistion)
            if viewModel.canShowNextButton || viewModel.canShowPrevButton {
                HStack(spacing: Layout.buttonsSpacing) {
                    if viewModel.canShowPrevButton {
                        OnboardingPreviousPageButton(onTap: viewModel.prevStep)
                    }
                    if viewModel.canShowNextButton {
                        AccentButton(title: Localization.next, action: viewModel.nextStep)
                            .disabled(!viewModel.isNextButtonEnabled)
                    }
                }
                .padding(.vertical, Layout.bottomPadding)
                .padding(.horizontal, Layout.horizontalPadding)
                .background(VisualEffect(style: .light).ignoresSafeArea())
                .aligned(.bottom)
            }
        }
        .onChange(of: viewModel.step) { step in
            switch step {
            case .height, .currentWeight, .desiredWeight:
                break
            default:
                hideKeyboard()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.step != .start, viewModel.step != .none {
                ToolbarItem(placement: .principal) {
                    OnboardingFlowIndicatorView(currentStep: viewModel.step,
                                                steps: viewModel.steps.filter { $0 != .none && $0 != .start })
                }
            }
        }
        .animation(.bouncy, value: viewModel.step)
        .navBarButton(isVisible: viewModel.context == .planChange,
                      content: Image.chevronLeft.foregroundStyle(.accent),
                      action: viewModel.dismiss)
    }

    private var transistion: AnyTransition {
        .asymmetric(insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading),
                    removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing))
    }

    @ViewBuilder
    var currentView: some View {
        switch viewModel.step {
        case .start:
            OnboardingStartView(onTap: viewModel.nextStep)
        case .sex:
            OnboardingPickerView(title: Localization.sexTitle,
                                 description: Localization.sexDescription,
                                 options: Sex.allCases,
                                 selectedOptions: [viewModel.sex].compactMap { $0 },
                                 onTap: viewModel.sexTapped)
        case .birthday:
            OnboardingDatePickerView(title: Localization.birthdayTitle,
                                     canChoosePast: true,
                                     date: $viewModel.birthdayDate)
        case .height:
            OnboardingSegmentedView(title: Localization.heightTitle,
                                    description: nil,
                                    value: $viewModel.height,
                                    inchValue: $viewModel.inchHeight,
                                    currentSegment: $viewModel.heightUnit,
                                    segments: HeightUnit.allCases)
            .id(viewModel.step)
        case .currentWeight:
            OnboardingSegmentedView(title: Localization.currentWeightTitle,
                                    description: nil,
                                    value: $viewModel.currentWeight,
                                    currentSegment: $viewModel.weightUnit,
                                    segments: WeightUnit.allCases)
            .id(viewModel.step)
        case .desiredWeight:
            OnboardingSegmentedView(title: Localization.desiredWeightTitle,
                                    description: Localization.desiredWeightDescription,
                                    value: $viewModel.desiredWeight,
                                    currentSegment: $viewModel.weightUnit,
                                    segments: WeightUnit.allCases)
            .id(viewModel.step)
        case .activityLevel:
            OnboardingPickerView(title: Localization.activityLevelTitle,
                                 description: Localization.activityLevelDescription,
                                 options: ActivityLevel.allCases,
                                 selectedOptions: [viewModel.activityLevel].compactMap { $0 },
                                 onTap: viewModel.activityLevelTapped)
        case .none:
            Color.white
        case .howOftenDoYouExercise:
            OnboardingPickerView(title: Localization.exerciseTitle,
                                 description: Localization.exerciseDescription,
                                 options: ExerciseActivity.allCases,
                                 selectedOptions: [viewModel.exerciseActivity].compactMap { $0 },
                                 onTap: viewModel.exerciseActivityTapped)
        case .whatTrainingYouDoing:
            OnboardingPickerView(title: Localization.trainingTitle,
                                 description: Localization.trainingDescription,
                                 options: ActivityType.allCases,
                                 selectedOptions: [viewModel.activityType].compactMap { $0 },
                                 onTap: viewModel.activityTypeTapped)
        case .estimatedExpenditure:
            OnboardingEstimatedExpenditureView(kcalAmount: viewModel.estimatedExpenditureKcal)
        case .calorieGoal:
            OnboardingPickerView(title: Localization.calorieGoalTitle,
                                 description: Localization.calorieGoalDescription,
                                 options: CalorieGoal.allCases,
                                 selectedOptions: [viewModel.calorieGoal].compactMap { $0 },
                                 onTap: viewModel.calorieGoalTapped)
        case .dietType:
            OnboardingPickerView(title: Localization.dietTypeTitle,
                                 description: nil,
                                 options: DietType.allCases,
                                 selectedOptions: [viewModel.dietType].compactMap { $0 },
                                 onTap: viewModel.dietTypeTapped)
        case .proteinLevel:
            OnboardingPickerView(title: Localization.proteinLevelTitle,
                                 description: nil,
                                 options: ProteinLevel.allCases,
                                 selectedOptions: [viewModel.proteinLevel].compactMap { $0 },
                                 onTap: viewModel.proteinLevelTapped)
        case .fastCalorieBurn:
            OnboardingFastCalorieBurnView(
                startPoint: $viewModel.startPoint,
                outsideRange: viewModel.outsideRange,
                insideRange: viewModel.insideRange,
                viewData: viewModel.calorieBurnData,
                isInitial: viewModel.context == .onboarding
            )
        }
    }

    var viewHorizontalPadding: CGFloat {
        switch viewModel.step {
        case .fastCalorieBurn: return .zero
        default: return Layout.horizontalPadding
        }
    }
}

// MARK: - Layout properties
private extension OnboardingScreen {
    enum Layout {
        static let horizontalPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 16
        static let buttonsSpacing: CGFloat = 8
        static let buttonsTopPadding: CGFloat = 40
    }

    enum Localization {
        static let next: LocalizedStringKey = "NextTitle"
        static let fastingGoalTitle = NSLocalizedString("Onboarding.fastingGoal.title",
                                                        comment: "")
        static let fastingGoalSubtitle = NSLocalizedString("Onboarding.fastingGoal.description",
                                                           comment: "")
        static let sexTitle = NSLocalizedString("Onboarding.sex.title", comment: "")
        static let sexDescription = NSLocalizedString("Onboarding.sex.description", comment: "")
        static let activityLevelTitle = NSLocalizedString("Onboarding.activityLevel.title", comment: "")
        static let activityLevelDescription = NSLocalizedString("Onboarding.activityLevel.description", comment: "")
        static let specialEventTitle = NSLocalizedString("Onboarding.specialEvent.title", comment: "")
        static let specialEventDescription = NSLocalizedString("Onboarding.specialEvent.description", comment: "")
        static let birthdayTitle = NSLocalizedString("Onboarding.birthdayTitle", comment: "")
        static let specialEventDateTitle = NSLocalizedString("Onboarding.specialEventDateTitle", comment: "")
        static let heightTitle = NSLocalizedString("Onboarding.height.title", comment: "")
        static let currentWeightTitle = NSLocalizedString("Onboarding.currentWeight.title", comment: "")
        static let desiredWeightTitle = NSLocalizedString("Onboarding.desiredWeight.title", comment: "")
        static let desiredWeightDescription = NSLocalizedString("Onboarding.desiredWeight.description", comment: "")
        static let exerciseTitle = NSLocalizedString("Onboarding.howOftenDoYouExercise.title", comment: "")
        static let exerciseDescription = NSLocalizedString("Onboarding.howOftenDoYouExercise.description", comment: "")
        static let trainingTitle = NSLocalizedString("Onboarding.whatTrainingYouDoing.title", comment: "")
        static let trainingDescription = NSLocalizedString("Onboarding.whatTrainingYouDoing.description", comment: "")
        static let calorieGoalTitle = NSLocalizedString("Onboarding.calorieGoal.title", comment: "")
        static let calorieGoalDescription = NSLocalizedString("Onboarding.calorieGoal.description", comment: "")
        static let dietTypeTitle = NSLocalizedString("Onboarding.dietType.title", comment: "")
        static let proteinLevelTitle = NSLocalizedString("Onboarding.proteinLevel.title", comment: "")
    }
}


struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OnboardingScreen(
                viewModel: OnboardingViewModel(
                    input: OnboardingInput(context: .onboarding,
                                           steps: OnboardingFlowStep.allCases),
                    output: { _ in }
                )
            )
        }
    }
}
