//
//  FoodCalendarView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import SwiftUI

struct FoodCalendarDayProgress: Equatable {
    let day: Date
    let goal: CGFloat
    let result: CGFloat
}

struct FoodCalendarView: View {

    let selectedDate: Date
    let dayProgress: [FoodCalendarDayProgress]
    let onTap: (Date) -> Void

    var body: some View {
        LazyHStack {
            ForEach(dayProgress, id: \.day) { progress in
                VStack(spacing: .zero) {
                    Text(progress.day.weekdayLetter.uppercased())
                        .font(.poppins(.description))
                        .foregroundStyle(.white)
                        .opacity(progress.day == selectedDate ? 1 : 0.7)
                        .padding(.bottom, .letterBottomPadding)
                    Text("\(progress.day.day)")
                        .font(.poppins(.body))
                        .foregroundStyle(.white)
                        .padding(.bottom, .numberBottomPadding)
                    Circle()
                        .fill(.white)
                        .frame(width: .circleWidth)
                        .padding(.bottom, .circleBottomPadding)
                        .opacity(progress.day == .now.beginningOfDay ? 1 : 0)
                }
                .frame(width: .dayWidth)
                .padding(.top, .dayVerticalPadding)
                .overlay {
                    ZStack {
                        if progress.day == selectedDate {
                            Color.accentColor
                                .opacity(0.1)
                        }
                        Capsule()
                            .trim(from: 0, to: progress.result / progress.goal)
                            .stroke(.white, lineWidth: .capsuleBorderWidth)
                            .rotationEffect(.degrees(180))
                    }
                }
                .continiousCornerRadius(.cornerRadius)
                .onTapGesture {
                    onTap(progress.day)
                }
                if progress.day != dayProgress.last?.day {
                    Spacer()
                }
            }
        }
    }
}

private extension CGFloat {
    static let letterBottomPadding: CGFloat = 0
    static let numberBottomPadding: CGFloat = 2
    static let dayVerticalPadding: CGFloat = 11
    static let cornerRadius: CGFloat = 56
    static let dayWidth: CGFloat = 44
    static let circleWidth: CGFloat = 4
    static let circleBottomPadding: CGFloat = 5
    static let capsuleBorderWidth: CGFloat = 1.5
}

#Preview {
    ZStack {
        Color.green
        FoodCalendarView(selectedDate: .now.beginningOfDay,
                         dayProgress: Date().daysOfWeek.map { .init(day: $0, goal: 1600, result: 450) },
                         onTap: { _ in })
        .padding(.horizontal, 16)
    }
}
