//
//  PeriodTrackerScreen.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI
import AppStudioStyles

struct PeriodTrackerScreen: View {

    @StateObject var viewModel: PeriodTrackerViewModel

    var body: some View {
        VStack(spacing: .zero) {
            CalendarProgressView(viewModel: viewModel.calendarViewModel,
                                 style: .fastingHealthOverview)
            PeriodTrackerCurrentPeriodView(
                configuration: viewModel.configuration,
                onTap: viewModel.logPeriod
            )
            .padding(.top, .periodViewTopPadding)
            .padding(.horizontal, .horizontalPadding)
            Spacer()
        }
        .navBarButton(placement: .principal,
                      content: dateNavigationView,
                      action: viewModel.scrollToToday)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var dateNavigationView: some View {
        DateNavigationView(date: $viewModel.currentDate,
                           dateFormat: "MMMdd",
                           isFutureAllowed: true,
                           onPrevDayTap: viewModel.trackPrevDay,
                           onNextDayTap: viewModel.trackNextDay)
    }
}

private extension CGFloat {
    static let periodViewTopPadding: CGFloat = 32
    static let horizontalPadding: CGFloat = 16
}

#Preview {
    PeriodTrackerScreen(viewModel: .init(router: .init(navigator: .init()),
                                         input: .init(),
                                         output: { _ in }))
}
