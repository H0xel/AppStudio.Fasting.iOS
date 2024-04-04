//
//  ScaleWeightHistoryTitleView.swift
//
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import SwiftUI

struct ScaleWeightHistoryTitleView: View {

    let onPlusTap: () -> Void

    var body: some View {
        HStack {
            Text(String.title)
                .font(.poppinsBold(.buttonText))
            Spacer()
            Button(action: onPlusTap) {
                Image.plus
                    .font(.title3)
            }
        }
        .foregroundStyle(Color.studioBlackLight)
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
}

private extension String {
    static let title = "ScaleWeightHistoryScreen.title".localized(bundle: .module)
}

#Preview {
    ScaleWeightHistoryTitleView {}
}
