//  
//  HealthOverviewScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine
import WaterCounter
import FastingWidget
import WeightWidget

private let scrollTriggerId = "scrollTriggerId"

struct HealthOverviewScreen: View {

    @StateObject var viewModel: HealthOverviewViewModel

    var body: some View {
        VStack(spacing: .zero) {
            CalendarProgressView(viewModel: viewModel.calendarViewModel,
                                 style: .fastingHealthOverview)
            .padding(.top, .calendarTopPadding)
            .padding(.bottom, .calendarBottomPadding)
            .background(.white)
            SwipeDaysView(viewModel: viewModel.swipeDaysViewModel) { day, _  in
                ScrollViewReader { proxy in
                    ScrollView {
                        Spacer(minLength: .verticalSpacing)
                            .id(scrollTriggerId)
                        VStack(spacing: .spacing) {
                            if viewModel.monetizationIsAvailable {
                                AllMonetizationBannerView(action: viewModel.presentPaywall)
                            }

                            FastingWidgetView(day: day,
                                              viewModel: viewModel.fastingWidgetViewModel)
                            WaterCounterWidget(date: day,
                                               viewModel: viewModel.waterCounterViewModel)

                            WeightWidgetRoute(date: day,
                                              viewModel: viewModel.weightWidgetViewModel)
                        }
                        Spacer(minLength: .verticalSpacing)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, .horizontalPadding)
                    .onChange(of: viewModel.currentDay) { value in
                        proxy.scrollTo(scrollTriggerId)
                    }
                }
            }
        }
        .background(Color.studioGreyFillProgress)
        .navBarButton(placement: .principal,
                      content: DateNavigationView(date: $viewModel.currentDay,
                                                  dateFormat: "MMMdd",
                                                  onPrevDayTap: viewModel.trackPrevDay,
                                                  onNextDayTap: viewModel.trackNextDay),
                      action: viewModel.scrollToToday)
        .navBarButton(content: Image.personFill.foregroundStyle(Color.studioBlackLight),
                      action: viewModel.presentProfile)
        .navigationBarTitleDisplayMode(.inline)
        .onAppearOnce {
            viewModel.appeared()
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 16
    static let calendarTopPadding: CGFloat = 8
    static let calendarBottomPadding: CGFloat = 16
    static let spacing: CGFloat = 8
}

struct HealthOverviewScreen_Previews: PreviewProvider {
    static var previews: some View {
        HealthOverviewScreen(
            viewModel: HealthOverviewViewModel(
                router: .init(navigator: .init()),
                input: .init(
                    fastingWidget: .init(
                        input: .init(fastingStatePublisher: Just(.mockActive).eraseToAnyPublisher()
                                    ),
                        output: { _ in }
                    ), 
                    weightUnits: .kg,
                    monetizationIsAvailable: Just(false).eraseToAnyPublisher()
                ),
                output: { _ in }
            )
        )
    }
}
