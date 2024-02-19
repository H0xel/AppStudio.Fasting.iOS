//
//  FastingScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation

struct FastingScreen: View {
    @StateObject var viewModel: FastingViewModel

    var body: some View {
        ZStack {
            VStack {
                FastingStagesView(stages: viewModel.fastingStages,
                                  currentStage: viewModel.currentStage,
                                  hasSubscription: viewModel.hasSubscription,
                                  onTap: viewModel.presentArticle)
                Spacer()
                FastingProgressView(status: viewModel.fastingStatus,
                                    plan: viewModel.fastingInterval.plan,
                                    hasSubscription: viewModel.hasSubscription,
                                    onTapStage: viewModel.presentArticle) {
                    viewModel.onChangeFastingTapped()
                }
                                    .padding(.horizontal, Layout.horizontalPadding)
                Spacer()
                FastingIntervalView(fastStarts: viewModel.fastingStartTime,
                                    fastEnds: viewModel.fastingEndTime,
                                    status: viewModel.fastingStatus,
                                    onEdit: viewModel.changeFastingTime)
                .padding(.bottom, Layout.timeBottomPadding)
                .padding(.horizontal, Layout.horizontalPadding)
                AccentButton(title: .localizedString(viewModel.isFastingActive
                                                     ? Localization.endFasting
                                                     : Localization.startFasting),
                             action: viewModel.toggleFasting)
                .padding(.horizontal, Layout.horizontalPadding)
            }
            .padding(.bottom, Layout.bottomPadding)
            .padding(.top, Layout.topPadding)
            .animation(.fastingStageChage, value: viewModel.fastingStatus)

            if let discountPercent = viewModel.discountPaywallInfo?.discount, !viewModel.hasSubscription {
                DiscountPaywallPinView(discountPercent: 50)
                    .aligned(.topLeft)
                    .padding(.top, Layout.discountPinTopPadding)
                    .onTapGesture {
                        viewModel.pinTapped()
                    }
            }
        }
    }
}

// MARK: - Layout properties
private extension FastingScreen {
    enum Layout {
        static let horizontalPadding: CGFloat = 32
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 16
        static let timeBottomPadding: CGFloat = 25
        static var discountPinTopPadding: CGFloat { UIScreen.isSmallDevice ? 80 : 90 }
    }
}

// MARK: - Localization
private extension FastingScreen {
    enum Localization {
        static let startFasting: LocalizedStringKey = "FastingScreen.startFasting"
        static let endFasting: LocalizedStringKey = "FastingScreen.endFasting"
    }
}

struct FastingScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FastingViewModel(input: .init(), output: { _ in })
        viewModel.router = .init(navigator: .init())
        return ModernNavigationView {
            FastingScreen(viewModel: viewModel)
        }
    }
}
