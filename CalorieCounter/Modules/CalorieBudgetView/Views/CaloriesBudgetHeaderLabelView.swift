//
//  CaloriesBudgetHeaderLabelView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.01.2024.
//

import SwiftUI

struct CaloriesBudgetHeaderLabelView: View {
    let calories: Double
    let title: String
    let isLargeHeader: Bool

    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            Text(calories.formattedCaloriesString)
                .foregroundStyle(.white)
                .font(headerFont)
            Text(title)
                .foregroundStyle(.white)
                .font(.poppins(.description))
        }
        .animation(nil, value: calories)
    }

    private var spacing: CGFloat {
        isLargeHeader ? 4 : 7
    }

    private var headerFont: Font {
        isLargeHeader ? .poppins(.headerL) : .poppins(.headerM)
    }
}

#Preview {
    HStack(alignment: .center) {
        CaloriesBudgetHeaderLabelView(calories: 1666, title: "title", isLargeHeader: false)
        CaloriesBudgetHeaderLabelView(calories: 777, title: "title 2", isLargeHeader: true)
    }
    .background(.red)
}
