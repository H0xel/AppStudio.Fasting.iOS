//
//  WeightGoalOverweightView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI

struct WeightGoalOverweightView: View {
    var body: some View {
        HStack(spacing: .spacing) {
            Text(String.text)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioBlackLight)
                .aligned(.left)
            Text("🏃‍♀️")
                .font(.title)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .verticalPadding)
        .background(Color(.beige))
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
}

private extension String {
    static let text = "WeightGoalOverweightView.text".localized(bundle: .module)
}

#Preview {
    WeightGoalOverweightView()
}
