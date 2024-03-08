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

struct FastingHealthProgressScreen: View {

    @StateObject var viewModel: HealthProgressViewModel

    var body: some View {
        ScrollView {
            Spacer(minLength: .topSpacing)
            VStack(spacing: .spacing) {
                VStack(spacing: .zero) {
                    if viewModel.isBodyMassHintPresented {
                        HealthProgressHintView(
                            hint: .bodyMass(onLearnMore: viewModel.presentBodyMassIndexInfo),
                            onHide: viewModel.closeBodyMassIndexHint
                        )
                    }
                    BodyMassIndexView(index: viewModel.bodyMassIndex, 
                                      infoTap: viewModel.presentBodyMassIndexInfo)
                }
                HealthProgressBarChartView(
                    title: .fastingChartTitle,
                    subtitle: .fastingChartSubtitle,
                    icon: .init(.circleInfo),
                    items: viewModel.fastingChartItems,
                    onIconTap: viewModel.presentFastingInfo
                )
            }
            .padding(.horizontal, .horizontalPadding)
        }
        .scrollIndicators(.hidden)
        .background(Color.studioGrayFillProgress)
        .navBarButton(placement: .principal,
                      content: navigationTitle,
                      action: {})
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.bouncy, value: viewModel.isBodyMassHintPresented)
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
}

private extension String {
    static let navigationTitle = "FastingHealthProgressScreen.title".localized(bundle: .module)
    static let fastingChartTitle = "FastingHealthProgressScreen.fastingTitle".localized(bundle: .module)
    static let fastingChartSubtitle = "FastingHealthProgressScreen.fastingSubtitle".localized(bundle: .module)
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
                inputPublisher: Just(FastingHealthProgressInput(
                    bodyMassIndex: 22.3,
                    fastingChartItems: HealthProgressBarChartItem.mock
                )).eraseToAnyPublisher(),
                output: { _ in }
            )
        )
    }
}
