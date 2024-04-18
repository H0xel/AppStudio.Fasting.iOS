//
//  HealthProgressScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine
import AppStudioModels

struct FastingHealthProgressScreen: View {

    @StateObject var viewModel: HealthProgressViewModel

    var body: some View {
        ScrollView {
            Spacer(minLength: .topSpacing)
            VStack(spacing: .spacing) {
                viewModel.weightGoalRoute

                HealthProgressBarChartView(
                    widgetInput: .fasting,
                    items: viewModel.fastingChartItems, 
                    isMonetization: viewModel.isMonetization,
                    output: viewModel.handleFastingWidgetOutput
                )

                HealthLinesChartView(input: .weight(with: viewModel.weightChartItems), 
                                     isMonetization: viewModel.isMonetization,
                                     output: viewModel.handleWeightWidgetOutput)
                .modifier(BottomHealthWidgetHintModifier(isHintPresented: viewModel.isWeightHintPresented,
                                                         hint: .weight,
                                                         onClose: viewModel.closeWeightHint) {
                    viewModel.presentWeightInfo(source: "learn_more")
                })
                BodyMassIndexView(index: viewModel.bodyMassIndex) {
                    viewModel.presentBodyMassIndexInfo(source: "info")
                }
                .modifier(BottomHealthWidgetHintModifier(isHintPresented: viewModel.isBodyMassHintPresented,
                                                         hint: .bodyMass,
                                                         onClose: viewModel.closeBodyMassIndexHint,
                                                         onLearnMore: {
                    viewModel.presentBodyMassIndexInfo(source: "learn_more")
                }))

                HealthProgressBarChartView(
                    widgetInput: .water,
                    items: viewModel.waterChartItems, 
                    isMonetization: viewModel.isMonetization,
                    output: viewModel.handleWaterWidgetOutput
                )
            }
            .padding(.horizontal, .horizontalPadding)
            Spacer(minLength: .bottomSpacing)
        }
        .scrollIndicators(.hidden)
        .background(Color.studioGrayFillProgress)
        .onAppear {
            viewModel.updateWeight()
            viewModel.updateWater()
        }
        .navBarButton(placement: .principal,
                      content: navigationTitle,
                      action: {})
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.bouncy, value: viewModel.isBodyMassHintPresented)
        .animation(.bouncy, value: viewModel.isWeightHintPresented)
    }

    private var navigationTitle: some View {
        Text(String.navigationTitle)
            .font(.poppins(.buttonText))
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let topSpacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let spacing: CGFloat = 8
    static let bottomSpacing: CGFloat = 48
}

private extension String {
    static let navigationTitle = "FastingHealthProgressScreen.title".localized(bundle: .module)
}

// MARK: - Localization
private extension FastingHealthProgressScreen {
    enum Localization {
        static let title: LocalizedStringKey = "HealthProgressScreen"
    }
}

struct HealthProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        FastingHealthProgressScreen(
            viewModel: HealthProgressViewModel(
                isMonetizationExpAvailablePublisher: Just(false).eraseToAnyPublisher(),
                inputPublisher: Just(FastingHealthProgressInput(
                    bodyMassIndex: 22.3,
                    weightUnits: .kg,
                    fastingChartItems: HealthProgressBarChartItem.mock,
                    fastingHistoryChartItems: .mock,
                    fastingHistoryData: .mock
                )).eraseToAnyPublisher(),
                output: { _ in }
            )
        )
    }
}
