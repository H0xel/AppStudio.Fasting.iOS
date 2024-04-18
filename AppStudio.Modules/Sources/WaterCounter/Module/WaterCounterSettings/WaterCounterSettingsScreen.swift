//  
//  WaterCounterSettingsScreen.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct WaterCounterSettingsScreen: View {
    @StateObject var viewModel: WaterCounterSettingsViewModel

    var body: some View {
        VStack(alignment: .center, spacing: .spacing) {
            // MARK: - Title
            Text(Localization.title)
                .font(.poppinsBold(.headerS))
                .foregroundStyle(Color.studioBlackLight)
                .padding(.top, .topPadding)

            // MARK: - Items
            VStack(spacing: .itemSpacing) {
                WaterCounterSettingsItemView(icon: .goal,
                                             title: Localization.dailyGoalTitle,
                                             valueTitle: viewModel.goalValueTitle,
                                             onTap: viewModel.showDaylyGoalEditor)
                WaterCounterSettingsItemView(icon: .glass,
                                             title: Localization.preferredVolumeTitle,
                                             valueTitle: viewModel.prefferedVolumeTitle,
                                             onTap: viewModel.showPrefferedValueEditor)
                WaterCounterSettingsItemView(icon: .rulet,
                                             title: Localization.unitsTitle,
                                             valueTitle: viewModel.unitsTitle,
                                             onTap: viewModel.showUnitsEditor)
            }
            .continiousCornerRadius(.cornerRadius)

            // MARK: - Close button
            Button(action: {
                viewModel.close()
            }, label: {
                HStack(spacing: .emptySpacing) {
                    Spacer()
                    Text(Localization.closeButtonTitle)
                        .font(.poppins(.buttonText))
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.vertical, .closeButtonVerticalPadding)
                    Spacer()
                }
                .border(configuration: .init(cornerRadius: .cornerRadius, color: .studioGreyStrokeFill, lineWidth: .borderWidth))
            })
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let spacing: CGFloat = 40
    static let itemSpacing: CGFloat = 2

    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 0.5

    static let topPadding: CGFloat = 32
    static let horizontalPadding: CGFloat = 24
    static let closeButtonVerticalPadding: CGFloat = 19.5
}

// MARK: - Localization
private extension WaterCounterSettingsScreen {
    enum Localization {
        static let title = NSLocalizedString("WaterCounterSettingsScreen.title", bundle: .module, comment: "")
        static let dailyGoalTitle = NSLocalizedString("WaterCounterSettingsScreen.dailyGoal.title", bundle: .module, comment: "")
        static let preferredVolumeTitle = NSLocalizedString("WaterCounterSettingsScreen.preferredVolume.title", bundle: .module, comment: "")
        static let unitsTitle = NSLocalizedString("WaterCounterSettingsScreen.units.title", bundle: .module, comment: "")
        static let closeButtonTitle = NSLocalizedString("WaterCounterSettingsScreen.closeButton.title", bundle: .module, comment: "")
    }
}

struct WaterCounterSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        WaterCounterSettingsScreen(
            viewModel: WaterCounterSettingsViewModel { _ in }
        )
    }
}
