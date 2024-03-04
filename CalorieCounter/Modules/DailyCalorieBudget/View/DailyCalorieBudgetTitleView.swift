//
//  DailyCalorieBudgetTitleView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI

struct DailyCalorieBudgetTitleView: View {
    let kcal: String

    var body: some View {
        VStack(spacing: .spacing) {
            Text("DailyCalorieBudget.title")
                .font(.poppins(.buttonText))

            Text(kcal)
                .font(.poppins(.accentS))
        }
        .padding(.top, .topPadding)
    }
}

private extension CGFloat {
    static var topPadding: CGFloat { 40 }
    static var spacing: CGFloat { 8 }
}

#Preview {
    DailyCalorieBudgetTitleView(kcal: "1,439")
}
