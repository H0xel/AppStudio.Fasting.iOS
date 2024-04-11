//  
//  WeightProgressScreen.swift
//  FastingTests
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import AppStudioNavigation
import Charts
import AppStudioStyles
import AppStudioModels

@available(iOS 17.0, *)
struct WeightProgressScreen: View {
    @StateObject var viewModel: WeightProgressViewModel

    @State private var animationEnabled = true
    @State private var animationTask: Task<(), Error>?

    var body: some View {
        ScrollView {
            Spacer(minLength: .topSpacing)
            VStack(spacing: .zero) {
                WeightProgressChipsView(selectedScale: $viewModel.chartScale,
                                        scales: DateChartScale.allCases)
                if let date = viewModel.selectedDate {
                    WeightProgressSelectedDayView(
                        selectedDate: date,
                        scaleWeight: viewModel.selectedDateScaleWeight,
                        trueWeight: viewModel.selectedDateTrueWeight, 
                        onClose: viewModel.closeSelectedView
                    )
                    .frame(height: .selectedDayHeight)
                    .padding(.top, .selectedDayTopPadding)
                    .padding(.bottom, .selectedDayBottomPadding)
                    .padding(.horizontal, .horizontalPadding)
                    .transition(.scale)
                } else {
                    WeightProgressDatesView(
                        startDate: viewModel.startDate,
                        endDate: viewModel.endDate,
                        minDate: viewModel.minDate,
                        output: viewModel.handle(weightProgressWeightOutput:)
                    )
                    .padding(.vertical, .datesVerticalPadding)
                    .animation(nil, value: viewModel.chartScale)
                    WeightProgressWeightInfoView(weight: viewModel.averageWeight,
                                                 weightChange: viewModel.changeOverPeriod)
                    .animation(nil, value: viewModel.chartScale)
                    .padding(.bottom, .infoBottomPadding)
                }

                WeightProgressChart(chartItems: viewModel.chartItems,
                                    chartScale: viewModel.chartScale,
                                    currentItem: $viewModel.startDate,
                                    selectedDate: $viewModel.selectedDate)
                WeightProgressChartAnnotationView(items: viewModel.annotationItems,
                                                  onTap: viewModel.toggleVisibility)
                    .padding(.horizontal, .horizontalPadding)
                    .padding(.top, .annotationTopPadding)
                WeightProgressAnalyticsView(trueWeight: viewModel.currentTrueWeight,
                                            weeklyChange: viewModel.weeklyChanges,
                                            projection: viewModel.weightProjection,
                                            weightUnits: viewModel.weightUnits)
                .padding(.top, .analyticsTopPadding)
                .padding(.horizontal, .horizontalPadding)
                .padding(.bottom, .analyticsBottomPadding)

                ScaleWeightHistoryScreen(viewModel: viewModel.scaleWeightHistoryViewModel)
                    .padding(.horizontal, .horizontalPadding)
            }
            Spacer(minLength: .bottomSpacing)
        }
        .animation(.easeInOut, value: viewModel.chartScale)
        .animation(animationEnabled ? .bouncy(duration: 0.35) : nil, value: viewModel.selectedDate?.startOfTheDay)
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(placement: .principal,
                      content: navigationTitle,
                      action: {})
        .navBarButton(content: backButton,
                      action: viewModel.dismiss)
        .navBarButton(placement: .topBarTrailing,
                      content: Image.widgetInfo,
                      action: viewModel.presentInfo)
        .onChange(of: viewModel.selectedDate) { newValue in
            animationEnabled = false
            animationTask?.cancel()
            animationTask = Task {
                try await Task.sleep(seconds: 0.5)
                if !Task.isCancelled {
                    animationEnabled = true
                }
            }

        }
    }

    private var navigationTitle: some View {
        Text(String.navBarTitle)
            .foregroundStyle(Color.studioBlackLight)
            .font(.poppins(.buttonText))
    }

    private var backButton: some View {
        Image.chevronLeft
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension String {
    static let navBarTitle = "WeightProgressScreen.title".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let topSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 48
    static let datesVerticalPadding: CGFloat = 24
    static let analyticsTopPadding: CGFloat = 24
    static let analyticsBottomPadding: CGFloat = 40
    static let infoBottomPadding: CGFloat = 16
    static let selectedDayBottomPadding: CGFloat = 13
    static let selectedDayTopPadding: CGFloat = 16
    static let annotationTopPadding: CGFloat = 16
    static let selectedDayHeight: CGFloat = 112
}

@available(iOS 17.0, *)
struct WeightProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            WeightProgressScreen(
                viewModel: WeightProgressViewModel(
                    input: WeightProgressInput(weightUnits: .kg),
                    output: { _ in }
                )
            )
        }
    }
}
