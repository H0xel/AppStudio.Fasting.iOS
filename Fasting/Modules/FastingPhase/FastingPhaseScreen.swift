//  
//  FastingPhaseScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct FastingPhaseScreen: View {
    @StateObject var viewModel: FastingPhaseViewModel

    var body: some View {
        VStack(spacing: .zero) {
            CloseButtonView(action: viewModel.close)
                .background(backgroundColor)
            view
        }
    }

    @ViewBuilder
    private var view: some View {
        if viewModel.canShowArticle {
            VStack(spacing: .zero) {
                FastingPhaseImageView(currentStage: viewModel.stage,
                                      isLocked: viewModel.isLocked,
                                      onTap: viewModel.changeStage)
                    .aligned(.centerHorizontaly)
                    .padding(.vertical, Layout.imageVerticalPadding)
                    .background(backgroundColor)
                ScrollView {
                    VStack(spacing: .zero) {
                        FastingPhaseTitleView(title: viewModel.title,
                                              backgroundColor: backgroundColor,
                                              image: viewModel.image,
                                              isLocked: false)

                        FastingPhaseStartDescriptionView(title: viewModel.startDescription,
                                                         backgroundColor: backgroundColor)
                        .padding(.top, Layout.startDescriptionTopPadding)
                        .padding(.bottom, Layout.startDescriptionBottomPadding)

                        FastingPhaseArticleView(article: viewModel.article,
                                                pointColor: backgroundColor)
                            .padding(.horizontal, Layout.horizontalPadding)
                    }

                    .background(Color.white)
                }
                .background(
                    LinearGradient(colors: [backgroundColor, backgroundColor, .white, .white],
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
            }
        } else {
            FastingPhaseLockedView(stage: viewModel.stage,
                                   image: viewModel.image,
                                   onStageTap: viewModel.changeStage,
                                   onPaywallTap: viewModel.presentPaywall)
        }
    }

    private var backgroundColor: Color {
        viewModel.stage.backgroundColor
    }

    private var closeButton: some View {
        Image.xmarkUnfilled
            .foregroundStyle(.white)
            .fontWeight(.semibold)
    }
}

// MARK: - Layout properties
private extension FastingPhaseScreen {
    enum Layout {
        static let imageVerticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 32
        static let startDescriptionTopPadding: CGFloat = 32
        static let startDescriptionBottomPadding: CGFloat = 28
    }
}

// MARK: - Localization
private extension FastingPhaseScreen {
    enum Localization {
        static let title: LocalizedStringKey = "FastingPhaseScreen"
    }
}

struct FastingPhaseScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FastingPhaseScreen(
                viewModel: FastingPhaseViewModel(
                    input: FastingPhaseInput(isMonetizationExpAvailable: false, stage: .sugarDrop),
                    output: { _ in }
                )
            )
        }
    }
}
