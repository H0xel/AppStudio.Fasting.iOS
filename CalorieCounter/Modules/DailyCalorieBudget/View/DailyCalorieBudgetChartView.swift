//
//  DailyCalorieBudgetChartView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI
import AppStudioUI

struct DailyCalorieBudgetChartView: View {
    let viewData: ViewData
    let width: CGFloat
    @State private var proteinsWidth: CGFloat = 0
    @State private var fatsWidth: CGFloat = 0
    @State private var carbsWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: isSmallProteinsSection ? .leading : .center,
                       spacing: .titleBottomPadding) {
                    Text("DailyCalorieBudget.protein")
                        .font(.poppins(.body))
                    Text("\(Int(viewData.protein))")
                        .font(.poppinsBold(18))
                }
                .frame(minWidth: width * viewData.proteinProportion)
                .withViewWidthPreferenceKey
                .onViewWidthPreferenceKeyChange { newWidth in
                    proteinsWidth = newWidth
                }

                VStack(spacing: .titleBottomPadding) {
                    Text("DailyCalorieBudget.fat")
                        .font(.poppins(.body))
                    Text("\(Int(viewData.fat))")
                        .font(.poppinsBold(18))
                }
                .frame(maxWidth: width * viewData.fatProportion)
                .withViewWidthPreferenceKey
                .onViewWidthPreferenceKeyChange { newWidth in
                    fatsWidth = newWidth
                }

                VStack(alignment: isSmallCarbsSection ? .trailing : .center,
                       spacing: .titleBottomPadding) {
                    Text("DailyCalorieBudget.carbs")
                        .font(.poppins(.body))
                    Text("\(Int(viewData.carbs))")
                        .font(.poppinsBold(18))
                }
                .frame(minWidth: width * viewData.carbsProportion)
                .withViewWidthPreferenceKey
                .onViewWidthPreferenceKeyChange { newWidth in
                    carbsWidth = newWidth
                }
            }

            HStack(spacing: .zero) {
                horizontalDivider
                    .frame(width: proteinsWidth)
                    .offset(x: -(proteinsWidth - width * viewData.proteinProportion) / 2)
                horizontalDivider
                    .frame(width: fatsWidth)
                horizontalDivider
                    .frame(width: carbsWidth)
                    .offset(x: (carbsWidth - width * viewData.carbsProportion) / 2)
            }
            .padding(.top, .horizontalDividerTopPadding)
            .padding(.bottom, .horizontalDividerBottomPadding)

            HStack(spacing: .zero) {
                Color.studioOrange
                    .frame(width: width * viewData.proteinProportion, height: .chartHeight)
                    .corners([.topLeft, .bottomLeft], with: .cornerRadius)

                Color.studioGreen
                    .frame(width: width * viewData.fatProportion, height: .chartHeight)
                Color.studioBlue
                    .frame(width: width * viewData.carbsProportion, height: .chartHeight)
                    .corners([.bottomRight, .topRight], with: .cornerRadius)
            }
        }
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
    }

    private var isSmallCarbsSection: Bool {
        carbsWidth > width * viewData.carbsProportion
    }

    private var isSmallProteinsSection: Bool {
        proteinsWidth > width * viewData.proteinProportion
    }

    @ViewBuilder
    private var horizontalDivider: some View {
        Divider()
            .frame(width: .horizontalDividerWidth, height: .horizontalDividerHeight)
            .background(.black)
            .aligned(.centerHorizontaly)
    }
}

extension DailyCalorieBudgetChartView {
    struct ViewData {
        let protein: CGFloat
        let fat: CGFloat
        let carbs: CGFloat
        let calories: CGFloat

        var proteinProportion: CGFloat {
            max(0, protein * NutritionProfileContent.protein.caloriesPerGramm / calories)
        }

        var fatProportion: CGFloat {
            max(0, fat * NutritionProfileContent.fat.caloriesPerGramm / calories)
        }

        var carbsProportion: CGFloat {
            max(0, carbs * NutritionProfileContent.carbohydrates.caloriesPerGramm / calories)
        }
    }
}

private extension CGFloat {
    static var cornerRadius: CGFloat = 16
    static var chartHeight: CGFloat = 16
    static var topPadding: CGFloat = 10
    static var bottomPadding: CGFloat = 40
    static var titleBottomPadding: CGFloat = 4

    static var horizontalDividerWidth: CGFloat = 1
    static var horizontalDividerHeight: CGFloat = 24
    static var horizontalDividerTopPadding: CGFloat = 4
    static var horizontalDividerBottomPadding: CGFloat = 8
}

#Preview {
    DailyCalorieBudgetChartView(viewData: .init(protein: 34, fat: 110, carbs: 18, calories: 1213),
                                width: UIScreen.main.bounds.width)
}
