//
//  HealthProgressHintView.swift
//
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
//

import SwiftUI

struct HealthProgressHintView: View {

    let hint: HealthProgressHint
    let onHide: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            HStack {
                Text(hint.title)
                    .foregroundStyle(Color.studioBlackLight)
                    .font(.poppinsMedium(.body))
                Spacer()
                Button(action: onHide) {
                    Image.close
                        .foregroundStyle(Color.studioGreyPlaceholder)
                }
            }
            Text(hint.description)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
            Button(action: hint.onLearnMore) {
                HStack(spacing: .buttonSpacing) {
                    Text(String.learnMore)
                    Image.chevronRight
                }
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioBlackLight)
            }
        }
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPaddin)
        .padding(.horizontal, .horizontalPadding)
        .background(
            ZStack {
                Color.studioGreyStrokeFill
                    .corners([.topLeft, .topRight], with: .cornerRadius)
                Color.studioGrayFillProgress
                    .corners([.topLeft, .topRight], with: .cornerRadius)
                    .padding(.top, 1)
                    .padding(.horizontal, 1)
            }

        )
        .offset(y: .offset)

    }
}

private extension String {
    static let learnMore = "HealthProgressHint.learnMore".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let topPadding: CGFloat = 16
    static let bottomPaddin: CGFloat = 32
    static let spacing: CGFloat = 12
    static let buttonSpacing: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let offset: CGFloat = 16
    static let borderWidth: CGFloat = 1
}

#Preview {
    HealthProgressHintView(hint: .bodyMass {}) {}
        .padding(.horizontal, 16)
}
