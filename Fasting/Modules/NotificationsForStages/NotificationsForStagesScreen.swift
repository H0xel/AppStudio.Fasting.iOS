//  
//  NotificationsForStagesScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct NotificationsForStagesScreen: View {
    @StateObject var viewModel: NotificationsForStagesViewModel

    var body: some View {
        VStack(spacing: .zero) {

            NotificationsForStagesHeaderView()

            VStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    ForEach(FastingStage.allCases, id: \.self) { stage in

                        NotificationForStagesSelectionView(
                            stage: stage,
                            isSelected: viewModel.selectedStages.contains(stage)
                        ) {
                            if viewModel.selectedStages.contains(stage) {
                                viewModel.stageDeselected(stage: stage)
                            } else {
                                viewModel.stageSelected(stage: stage)
                            }
                        }
                    }
                }
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.cornerRadius)
                .padding(.bottom, .bottomPadding)

                HStack(spacing: .spacing) {
                    OnboardingPreviousPageButton(onTap: viewModel.closeTapped)
                    AccentButton(title: .localizedString("SaveTitle"), action: viewModel.saveTapped)
                }
                Spacer()
            }
            .padding(.horizontal, .horizontalPadding)
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let bottomPadding: CGFloat = 40
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 24
}

struct NotificationsForStagesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsForStagesScreen(
            viewModel: NotificationsForStagesViewModel(
                input: NotificationsForStagesInput(selectedStages: [.autophagy, .burning]),
                output: { _ in }
            )
        )
    }
}
