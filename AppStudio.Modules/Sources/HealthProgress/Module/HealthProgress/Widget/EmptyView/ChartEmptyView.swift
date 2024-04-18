//
//  LineChartEmptyView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioStyles

struct ChartEmptyView: View {

    let input: ChartEmptyStateInput
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: .spacing) {
            Image.chart
                .foregroundStyle(Color.studioBlackLight)
                .font(.poppinsMedium(.body))
            VStack(spacing: .titleSpacing) {
                Text(input.title)
                    .foregroundStyle(Color.studioBlackLight)
                    .font(.poppinsMedium(.body))
                Text(input.subtitle)
                    .foregroundStyle(Color.studioGreyText)
                    .font(.poppins(.description))
            }
            if let title = input.buttonTitle {
                Button(action: onTap) {
                    Text(title)
                        .foregroundStyle(Color.studioBlackLight)
                        .font(.poppins(.description))
                        .padding(.horizontal, .buttonHotizontalPadding)
                        .padding(.vertical, .buttonVerticalPadding)
                        .background(Color.studioGreyFillProgress)
                        .continiousCornerRadius(.buttonCornerRadius)
                }
            }
        }
    }
}

private extension CGFloat {
    static let titleSpacing: CGFloat = 8
    static let spacing: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let buttonVerticalPadding: CGFloat = 15
    static let buttonHotizontalPadding: CGFloat = 32
    static let buttonCornerRadius: CGFloat = 44
}

#Preview {
    ChartEmptyView(input: .weight, onTap: {})
}
