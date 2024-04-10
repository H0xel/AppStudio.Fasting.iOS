//
//  ProfileTargetWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import SwiftUI
import AppStudioModels

struct ProfileTargetWeightView: View {

    let targetWeight: WeightMeasure
    let calorieGoal: String
    let goal: CalorieGoal
    let weeklyWeightChange: String
    let onInfoTap: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Text(.targetWeight)
                .font(.poppins(.body))
                .foregroundStyle(.accent)
            ZStack {
                Image(.weightScales)
                HStack(alignment: .bottom, spacing: .weightSpacing) {
                    Text("\(Int(targetWeight.value))")
                        .font(.poppins(.accentS))
                    Text(targetWeight.units.title)
                        .font(.poppins(.description))
                        .offset(y: .weightUnitsOffset)
                }
                .foregroundStyle(.accent)
                .offset(x: .weightOffset)

                Color.studioRed
                    .frame(width: .lineWidth, height: .lineHeight)
            }
            .padding(.top, .imageTopPadding)

            HStack(spacing: .zero) {
                Spacer()
                infoLabel(title: .calorieGoal,
                          value: calorieGoal)
                if let title = weightChageTitle {
                    Spacer()
                    Spacer()
                    infoLabel(title: title,
                              value: weeklyWeightChange)
                }
                Spacer()
            }
            .padding(.top, .infoLabelTopPadding)
            .padding(.bottom, .bottomPadding)
        }
        .padding(.top, .topPadding)
        .padding(.horizontal, .horizontalPadding)
        .background(.white)
        .overlay(
            Button(action: onInfoTap) {
                Image(.infoCircle)
                    .padding(.infoButtonPadding)
            }
            .aligned(.topRight)
        )
    }

    private func infoLabel(title: LocalizedStringKey,
                           value: String) -> some View {
        VStack(spacing: .infoLabelSpacing) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyPlaceholder)
            Text(value)
                .font(.poppins(.body))
                .foregroundStyle(.accent)
        }
    }

    private var weightChageTitle: LocalizedStringKey? {
        switch goal {
        case .lose:
            return .weeklyWeightLoss
        case .maintain:
            return nil
        case .gain:
            return .weeklyWeightGain
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let infoLabelSpacing: CGFloat = 4
    static let bottomPadding: CGFloat = 32
    static let infoLabelTopPadding: CGFloat = 40
    static let topPadding: CGFloat = 16
    static let imageTopPadding: CGFloat = 16
    static let lineHeight: CGFloat = 80
    static let lineWidth: CGFloat = 2
    static let weightSpacing: CGFloat = 4
    static let weightUnitsOffset: CGFloat = -9
    static let weightOffset: CGFloat = 10
    static let infoButtonPadding: CGFloat = 13
}

private extension LocalizedStringKey {
    static let targetWeight: LocalizedStringKey = "ProfileScreen.targetWeight"
    static let calorieGoal: LocalizedStringKey = "ProfileScreen.calorieGoal"
    static let weeklyWeightLoss: LocalizedStringKey = "ProfileScreen.weeklyWeightLoss"
    static let weeklyWeightGain: LocalizedStringKey = "ProfileScreen.weeklyWeightGain"
}

#Preview {
    ZStack {
        Color.red
        ProfileTargetWeightView(targetWeight: .init(value: 104,
                                                    units: .kg),
                                calorieGoal: "1,447 kcal",
                                goal: .lose,
                                weeklyWeightChange: "-0,5 kg") {}
    }
}
