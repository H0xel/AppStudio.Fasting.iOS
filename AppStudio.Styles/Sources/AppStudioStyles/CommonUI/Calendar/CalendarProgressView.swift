//
//  CalendarProgressView.swift
//
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
//

import SwiftUI

public struct CalendarProgressView: View {

    @StateObject var viewModel: CalendarProgressViewModel
    let style: CalendarStyle

    public init(viewModel: CalendarProgressViewModel,
                style: CalendarStyle) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.style = style
    }

    public var body: some View {
        TabView(selection: $viewModel.currentWeek) {
            ForEach(viewModel.availableWeeks, id: \.self) { week in
                CalendarProgressWeekView(styles: style,
                                         selectedDate: viewModel.currentDay, 
                                         progress: viewModel.weekProgress(for: week),
                                         isFutereAllowed: viewModel.isFutureAllowed,
                                         onTap: viewModel.selectDate)
                .padding(.horizontal, .horizontalPadding)
                .background(.white.opacity(0.01))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: .calendarHeight)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let calendarHeight: CGFloat = 61
}

#Preview {
    CalendarProgressView(viewModel: .init(isFutureAllowed: false,
                                          withFullProgress: false),
                         style: .fastingHealthOverview)
}
