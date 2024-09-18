//  
//  PeriodOnboardingDetailsScreen.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct PeriodOnboardingDetailsScreen: View {
    @StateObject var viewModel: PeriodOnboardingDetailsViewModel

    let totalEllipses = 31
    let activeEllipses = 6

    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(spacing: .headerSpacing) {
                    Text("PeriodOnboardingDetailsScreen.title")
                        .font(.poppins(.buttonText))

                    HStack(alignment: .lastTextBaseline, spacing: .spacing) {
                        Text("4")
                            .font(.poppins(.accentS))
                        Text("PeriodOnboardingDetailsScreen.days")
                            .font(.poppins(.body))
                    }
                }
                .padding(.vertical, .headerVerticalPadding)

                VStack(spacing: .zero) {
                    HStack(spacing: .zero) {
                        PeriodGraphDescriptionView(
                            title: "PeriodOnboardingDetailsScreen.cycleStarted".localized(),
                            date: viewModel.cycleStartedDate,
                            image: .init(.Onboarding.curveLine),
                            withTrailingPadding: true
                        )

                        Spacer()

                        PeriodGraphDescriptionView(
                            title: "PeriodOnboardingDetailsScreen.ovulation".localized(),
                            date: viewModel.ovulationDate,
                            image: .init(.Onboarding.line)
                        )

                        Spacer()

                        PeriodGraphDescriptionView(
                            title: "PeriodOnboardingDetailsScreen.now".localized(),
                            date: viewModel.nowDate,
                            image: .init(.Onboarding.line),
                            withTrailingPadding: true
                        )
                    }

                    HStack(spacing: .spacing) {
                        ForEach(0..<totalEllipses, id: \.self) { index in
                            PeriodEllipseView(kind: index < activeEllipses ? .cycleStarted : .nothing)
                        }
                    }
                    .padding(.top, .elipseTopPadding)
                }
                .padding(.horizontal, .graphHorizontalPadding)
                .padding(.bottom, .graphBottomPadding)

                VStack(spacing: .headerSpacing) {
                    ForEach(0..<4) { _ in
                        PeriodOnboardingDescriptionView(viewData: .init(
                            subtitle: "September 30",
                            description: "PeriodOnboardingDetailsScreen.ovulation.description".localized(),
                            type: .ovulationDate))
                    }
                }
                .padding(.horizontal, .itemsHorizontalPadding)
            }
            .scrollIndicators(.hidden)

            HStack(spacing: .buttonsSpacing) {

                OnboardingPreviousPageButton(onTap: viewModel.prevStep)

                AccentButton(
                    title: .localizedString("Onboarding.next"),
                    backgroundColor: Color.studioBlueLight,
                    action: viewModel.nextStep
                )
            }
            .padding(.vertical, .bottomPadding)
            .padding(.horizontal, .viewHorizontalPadding)
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let viewHorizontalPadding: CGFloat = 32
    static let bottomPadding: CGFloat = 16
    static let buttonsSpacing: CGFloat = 8
    static let headerSpacing: CGFloat = 8
    static let headerVerticalPadding: CGFloat = 73
    static let curveLineTrailingPadding: CGFloat = 50
    static let graphHorizontalPadding: CGFloat = 24
    static let graphBottomPadding: CGFloat = 96
    static let itemsHorizontalPadding: CGFloat = 16
    static let elipseTopPadding: CGFloat = 16
}

// MARK: - Localization
private extension PeriodOnboardingDetailsScreen {
    enum Localization {
        static let title: LocalizedStringKey = "PeriodOnboardingDetailsScreen"
    }
}

struct PeriodOnboardingDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PeriodOnboardingDetailsScreen(
            viewModel: PeriodOnboardingDetailsViewModel(
                input: PeriodOnboardingDetailsInput(),
                output: { _ in }
            )
        )
    }
}
