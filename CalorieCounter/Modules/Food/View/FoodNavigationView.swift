//
//  FoodNavigationView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.04.2024.
//

import SwiftUI
import AppStudioStyles

struct FoodNavigationView: View {

    let calendarViewModel: CalendarProgressViewModel
    @ObservedObject var swipeDaysViewModel: SwipeDaysViewModel
    let onProfileTap: () -> Void
    let onPrevDayTap: (Date) -> Void
    let onNextDayTap: (Date) -> Void

    var body: some View {
        VStack(spacing: .spacing) {
            ZStack {
                Button(action: onProfileTap) {
                    Image.personFill
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .profileButtonWidth, height: .profileButtonWidth)

                }
                .padding(.leading, .leadingPadding)
                .aligned(.left)
                DateNavigationView(date: $swipeDaysViewModel.currentDay,
                                   foregroundColor: .white,
                                   onPrevDayTap: onPrevDayTap,
                                   onNextDayTap: onNextDayTap)
            }
            .frame(height: .navBarHeight)
            .foregroundStyle(.white)

            CalendarProgressView(viewModel: calendarViewModel, style: .calorieCounter)
                .frame(height: .calendarHeight)
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let calendarHeight: CGFloat = 61
    static let navBarHeight: CGFloat = 44
    static let leadingPadding: CGFloat = 24
    static let profileButtonWidth: CGFloat = 20
}

#Preview {
    FoodNavigationView(calendarViewModel: .init(isFutureAllowed: true, withFullProgress: false),
                       swipeDaysViewModel: .init(isFutureAllowed: true),
                       onProfileTap: {},
                       onPrevDayTap: { _ in },
                       onNextDayTap: { _ in })
}
