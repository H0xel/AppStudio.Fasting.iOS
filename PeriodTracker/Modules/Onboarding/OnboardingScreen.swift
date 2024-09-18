//  
//  OnboardingScreen.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 12.09.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import AppStudioUI
import AppStudioModels

struct OnboardingScreen: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            currentView
                .frame(maxWidth: .infinity)
                .padding(.horizontal, .viewHorizontalPadding)
                .transition(transition)
            if viewModel.canShowNextButton || viewModel.canShowPrevButton {
                HStack(spacing: .buttonsSpacing) {
                    if viewModel.canShowPrevButton {
                        OnboardingPreviousPageButton(onTap: viewModel.prevStep)
                    }
                    if viewModel.canShowNextButton {
                        AccentButton(
                            title: .localizedString("Onboarding.next"),
                            backgroundColor: Color.studioBlueLight,
                            action: viewModel.nextStep
                        )
                        .disabled(!viewModel.isNextButtonEnabled)
                    }
                }
                .padding(.vertical, .bottomPadding)
                .padding(.horizontal, .viewHorizontalPadding)
                .background(VisualEffect(style: .light).ignoresSafeArea())
                .aligned(.bottom)
            }
        }
        .onChange(of: viewModel.step) { _ in
            hideKeyboard()
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
    }

    @ViewBuilder
    var currentView: some View {
        switch viewModel.step {
        case .start:
            OnboardingStartView(
                viewData: .init(
                    image: Image(.Onboarding.periodOnboarding),
                    description: "Onboarding.description".localized(),
                    buttonTitle: "Onboarding.buttonTitle".localized(),
                    privacyURL: GlobalConstants.privacyPolicy,
                    termsURL: GlobalConstants.termsOfUse,
                    w2wViewData: nil,
                    withInterCome: false
                ),
                onTap: viewModel.handle
            )
        case .none:
            Color.white
        case .birthday:
            OnboardingDatePickerView(title: "Onboarding.birthday.title".localized(),
                                     description: "Onboarding.birthday.subTitle".localized(),
                                     canChoosePast: true,
                                     date: $viewModel.onboardingData.birthDay)
        case .lastPeriodStarted:
            OnboardingDatePickerView(title: "Onboarding.lastPeriod.title".localized(),
                                     description: "Onboarding.lastPeriod.subTitle".localized(),
                                     canChoosePast: true,
                                     date: $viewModel.onboardingData.lastPeriodDate)
        case .currentWeight:
            OnboardingSegmentedView(title: "Onboarding.lastPeriod.currentWeight".localized(),
                                    description: nil,
                                    value: $viewModel.onboardingData.currentWeight,
                                    currentSegment: $viewModel.onboardingData.currentWeightUnit,
                                    segments: WeightUnit.allCases)
            .id(viewModel.step)
        case .longLastPeriod:
            OnboardingSliderView(
                startPoint: $viewModel.startPointLastPeriod,
                outsideRange: 1...20,
                insideRange: 3...17,
                viewData: .init(
                    title: "How long does your periodusually last?",
                    statusViewData: viewModel.statusLastPeriod,
                    statusAmount: "\(Int(viewModel.startPointLastPeriod))",
                    statusDescription: "Most periods last between 3 to 7 days, so you're right on track!",
                    description: "Move bar to select the number\nof days"
                )
            )
        case .longTypicalCycle:
            OnboardingSliderView(
                startPoint: $viewModel.startPointTypicalMenstrualCycle,
                outsideRange: 1...20,
                insideRange: 3...17,
                viewData: .init(
                    title: "How long does your periodusually last?",
                    statusViewData: viewModel.statusMenstrualCycle,
                    statusAmount: "\(Int(viewModel.startPointTypicalMenstrualCycle))",
                    statusDescription: "A 32-day cycle is normal—menstrual cycles typically range from 21 to 35 days.",
                    description: "Move bar to select the number\nof days"
                )
            )
        case .regularIrregularCycle:
            OnboardingPickerView(title: "Onboarding.lastPeriod.menstrualPeriodTitle".localized(),
                                 description: nil,
                                 options: CyclePeriod.allCases,
                                 selectedOptions: [viewModel.onboardingData.cyclePeriod].compactMap { $0 },
                                 onTap: { viewModel.onboardingData.cyclePeriod = $0 })
        case .useOfBrithControl:
            OnboardingPickerView(title: "Onboarding.lastPeriod.menstrualPeriod.pharmacyTitle".localized(),
                                 description: nil,
                                 options: BirthControl.allCases,
                                 selectedOptions: [viewModel.onboardingData.useOfBirthControl].compactMap { $0 },
                                 onTap: { viewModel.onboardingData.useOfBirthControl = $0 })
        case .fertilityGoals:
            OnboardingPickerView(title: "Onboarding.lastPeriod.fertilityGoals.title".localized(),
                                 description: nil,
                                 options: FertilityGoal.allCases,
                                 selectedOptions: viewModel.onboardingData.fertilityGoals,
                                 onTap: { selectedItem in
                if viewModel.onboardingData.fertilityGoals.contains(selectedItem) {
                    viewModel.onboardingData.fertilityGoals.removeAll { $0 == selectedItem }
                } else {
                    viewModel.onboardingData.fertilityGoals.append(selectedItem)
                }
            })
        case .trackSpecificSymptoms:
            EmptyView()
        case .topics:
            OnboardingPickerView(title: "Onboarding.topics.title".localized(),
                                 description: nil,
                                 options: Topic.allCases,
                                 selectedOptions: viewModel.onboardingData.topics,
                                 onTap: { selectedTopic in
                if viewModel.onboardingData.topics.contains(selectedTopic) {
                    viewModel.onboardingData.topics.removeAll { $0 == selectedTopic }
                } else {
                    viewModel.onboardingData.topics.append(selectedTopic)
                }
            })
        case .features:
            OnboardingPickerView(title: "Onboarding.features.title".localized(),
                                 description: nil,
                                 options: Feature.allCases,
                                 selectedOptions: viewModel.onboardingData.features,
                                 onTap: { selectedFeature in
                if viewModel.onboardingData.features.contains(selectedFeature) {
                    viewModel.onboardingData.features.removeAll { $0 == selectedFeature }
                } else {
                    viewModel.onboardingData.features.append(selectedFeature)
                }
            })
        }
    }

    private var transition: AnyTransition {
        .asymmetric(insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading),
                    removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing))
    }
}

private extension CGFloat {
    static let viewHorizontalPadding: CGFloat = 32
    static let bottomPadding: CGFloat = 16
    static let buttonsSpacing: CGFloat = 8
    static let buttonsTopPadding: CGFloat = 40
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(
            viewModel: OnboardingViewModel(
                input: OnboardingInput(steps: []),
                output: { _ in }
            )
        )
    }
}
