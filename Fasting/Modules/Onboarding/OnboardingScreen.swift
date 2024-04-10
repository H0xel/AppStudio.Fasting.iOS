//
//  OnboardingScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioModels
import AppStudioStyles

struct OnboardingScreen: View {
    @StateObject var viewModel: OnboardingViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            currentView
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Layout.horizontalPadding)
                .transition(transistion)
            if viewModel.canShowNextButton || viewModel.canShowPrevButton {
                HStack(spacing: Layout.buttonsSpacing) {
                    if viewModel.canShowPrevButton {
                        OnboardingPreviousPageButton(onTap: viewModel.prevStep)
                    }
                    if viewModel.canShowNextButton {
                        AccentButton(title: .localizedString(Localization.next), action: viewModel.nextStep)
                            .disabled(!viewModel.isNextButtonEnabled)
                    }
                }
                .padding(.bottom, Layout.bottomPadding)
                .padding(.horizontal, Layout.horizontalPadding)
                .background(VisualEffect(style: .light).ignoresSafeArea())
                .aligned(.bottom)
            }
        }
        .onChange(of: viewModel.step) { step in
            switch step {
            case .height, .currentWeight, .desiredWeight:
                isFocused = true
            default:
                isFocused = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.step != .start, viewModel.step != .none {
                ToolbarItem(placement: .principal) {
                    OnboardingFlowIndicatorView(currentStep: viewModel.step)
                }
            }
        }
        .animation(.bouncy, value: viewModel.step)
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
        case .fastingGoal:
            OnboardingPickerView(title: Localization.fastingGoalTitle,
                                 description: Localization.fastingGoalSubtitle,
                                 options: FastingGoal.allCases,
                                 selectedOptions: viewModel.fastingGoals,
                                 onTap: viewModel.fastingGoalTapped)
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
        case .currentWeight:
            OnboardingSegmentedView(title: Localization.currentWeightTitle,
                                    description: nil,
                                    value: $viewModel.currentWeight,
                                    currentSegment: $viewModel.weightUnit,
                                    segments: WeightUnit.allCases)
        case .desiredWeight:
            OnboardingSegmentedView(title: Localization.desiredWeightTitle,
                                    description: Localization.desiredWeightDescription,
                                    value: $viewModel.desiredWeight,
                                    currentSegment: $viewModel.weightUnit,
                                    segments: WeightUnit.allCases)
        case .activityLevel:
            OnboardingPickerView(title: Localization.activityLevelTitle,
                                 description: nil,
                                 options: ActivityLevel.allCases,
                                 selectedOptions: [viewModel.activityLevel].compactMap { $0 },
                                 onTap: viewModel.activityLevelTapped)
        case .specialEvent:
            OnboardingPickerView(title: Localization.specialEventTitle,
                                 description: Localization.specialEventDescription,
                                 options: SpecialEvent.allCases,
                                 selectedOptions: [viewModel.specialEvent].compactMap { $0 },
                                 onTap: viewModel.specialEventTapped)
        case .specialEventDate:
            OnboardingDatePickerView(title: Localization.specialEventDateTitle,
                                     canChoosePast: false,
                                     date: $viewModel.specialEventDate)
        case .none:
            Color.white
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
        static let specialEventTitle = NSLocalizedString("Onboarding.specialEvent.title", comment: "")
        static let specialEventDescription = NSLocalizedString("Onboarding.specialEvent.description", comment: "")
        static let birthdayTitle = NSLocalizedString("Onboarding.birthdayTitle", comment: "")
        static let specialEventDateTitle = NSLocalizedString("Onboarding.specialEventDateTitle", comment: "")
        static let heightTitle = NSLocalizedString("Onboarding.height.title", comment: "")
        static let currentWeightTitle = NSLocalizedString("Onboarding.currentWeight.title", comment: "")
        static let desiredWeightTitle = NSLocalizedString("Onboarding.desiredWeight.title", comment: "")
        static let desiredWeightDescription = NSLocalizedString("Onboarding.desiredWeight.description", comment: "")
    }
}


struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OnboardingScreen(
                viewModel: OnboardingViewModel(
                    input: OnboardingInput(),
                    output: { _ in }
                )
            )
        }
    }
}
