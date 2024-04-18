//
//  WeightGoalSuccessView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI

struct WeightGoalSuccessView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacing) {
                Text(String.title)
                    .font(.poppinsMedium(.body))
                Text(String.subtitle)
                    .font(.poppins(.body))
            }
            .foregroundStyle(Color.studioBlackLight)
            .multilineTextAlignment(.leading)
            Spacer()
            ZStack {
                Image(.successIcon)
                Image(.confetty)
            }
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
}

private extension String {
    static let title = "WeightGoalSuccessView.title".localized(bundle: .module)
    static let subtitle = "WeightGoalSuccessView.subtitle".localized(bundle: .module)
}

#Preview {
    WeightGoalSuccessView()
}
