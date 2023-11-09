//  
//  ChooseFastingPlanScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioFoundation

struct ChooseFastingPlanScreen: View {
    @StateObject var viewModel: ChooseFastingPlanViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text(Localization.title)
                .font(.poppins(.headerL))
                .padding(.top, Layout.titleTopPadding)
                .padding(.bottom, Layout.titleBottomPadding)

            Text(Localization.description)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.descriptionBottomPadding)
                .font(.poppins(.body))

            SnapCarousel(index: $viewModel.index, items: viewModel.plans) { plan in
                    FastingPlanView(plan: plan.plan) {
                        viewModel.choosePlanTapped()
                    }
            }
            Spacer(minLength: 20)
        }
        .multilineTextAlignment(.center)
        .if(viewModel.context != .onboarding) {
            $0.navBarButton(
                isVisible: true,
                content: Image.xmark.foregroundColor(.black)
            ) {
                viewModel.backButtonTapped()
            }
        }
        .navigationBarHidden(false)
    }
}

// MARK: - Layout properties
private extension ChooseFastingPlanScreen {
    enum Layout {
        static let titleTopPadding: CGFloat = 12
        static let titleBottomPadding: CGFloat = 48
        static let descriptionBottomPadding: CGFloat = 48
        static let horizontalPadding: CGFloat = 32
    }
}

// MARK: - Localization
private extension ChooseFastingPlanScreen {
    enum Localization {
        static let title: LocalizedStringKey = "ChooseFastingPlan.title"
        static let description: LocalizedStringKey = "ChooseFastingPlan.description"
    }
}

struct ChooseFastingPlanScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFastingPlanScreen(
            viewModel: ChooseFastingPlanViewModel(
                input: ChooseFastingPlanInput(context: .onboarding),
                output: { _ in }
            )
        )
    }
}