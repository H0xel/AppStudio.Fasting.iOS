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
        VStack(spacing: .zero) {
            Text(viewModel.context == .onboarding ?
                    Localization.titleOnboarding :
                    Localization.title)
                .font(.adaptivePoppins(font: .headerL, smallDeviceFont: .headerM))
                .padding(.top, Layout.titleTopPadding)
                .padding(.bottom, Layout.titleBottomPadding)
                .foregroundStyle(.accent)

            Text(Localization.description)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.descriptionBottomPadding)
                .font(.poppins(.body))
                .lineSpacing(Layout.lineSpacing)
                .foregroundStyle(.accent)

            SnapCarousel(index: $viewModel.index,
                         items: viewModel.plans) { plan in
                FastingPlanView(plan: plan.plan) {
                    viewModel.choosePlanTapped()
                }
            }
            Spacer(minLength: 20)
        }
        .overlay {
            VStack(spacing: .zero) {
                HStack(spacing: Layout.bannerSpacing) {
                    Image.checkmark
                        .foregroundStyle(.green)
                    Text("W2W.banner.activateSuccessfully")
                        .font(.poppins(.body))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, Layout.bannerHorizontalPadding)
                .padding(.vertical, Layout.bannerVerticalPadding)
                .background(Color.studioBlackLight)
                .continiousCornerRadius(Layout.bannerCornerRadius)
                Spacer()
            }
            .padding(.top, Layout.bannerTopPadding)
            .ignoresSafeArea()
            .opacity(viewModel.showW2WActivationBanner ? 1 : 0)
            .animation(.interpolatingSpring, value: viewModel.showW2WActivationBanner)
        }
        .multilineTextAlignment(.center)
        .navBarButton(isVisible: viewModel.context != .onboarding && viewModel.context != .w2wOnboarding,
                      content: Image.xmarkUnfilled.foregroundColor(.accent),
                      action: viewModel.backButtonTapped)
        .navigationBarHidden(viewModel.context == .w2wOnboarding)
    }
}

// MARK: - Layout properties
private extension ChooseFastingPlanScreen {
    enum Layout {
        static let titleTopPadding: CGFloat = 12
        static let titleBottomPadding: CGFloat = 32
        static let descriptionBottomPadding: CGFloat = 40
        static let horizontalPadding: CGFloat = 32
        static let lineSpacing: CGFloat = 3
        static let bannerSpacing: CGFloat = 12
        static let bannerCornerRadius: CGFloat = 20
        static let bannerTopPadding: CGFloat = 50
        static let bannerHorizontalPadding: CGFloat = 16
        static let bannerVerticalPadding: CGFloat = 19
    }
}

// MARK: - Localization
private extension ChooseFastingPlanScreen {
    enum Localization {
        static let title: LocalizedStringKey = "ChooseFastingPlan.title"
        static let titleOnboarding: LocalizedStringKey = "ChooseFastingPlan.title.onboarding"
        static let description: LocalizedStringKey = "ChooseFastingPlan.description"
    }
}

struct ChooseFastingPlanScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseFastingPlanScreen(
                viewModel: ChooseFastingPlanViewModel(
                    input: ChooseFastingPlanInput(context: .onboarding),
                    output: { _ in }
                )
            )
        }
    }
}
