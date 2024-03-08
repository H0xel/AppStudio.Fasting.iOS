//
//  BodyMassIndexView.swift
//
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI

struct BodyMassIndexView: View {

    let index: Double
    let infoTap: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text(String.title)
                    .font(.poppinsBold(.buttonText))
                    .foregroundStyle(Color.studioBlackLight)
                Spacer()
                Button(action: infoTap) {
                    Image(.circleInfo)
                }
            }
            BodyMassIndexLabelView(index: index)
                .padding(.top, .labelTopPadding)
            BodyMassIndexScaleView(index: index)
                .padding(.top, .scaleTopPadding)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let topPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let labelTopPadding: CGFloat = 16
    static let scaleTopPadding: CGFloat = 4
}

private extension String {
    static let title = "BodyMassIndexView.title".localized(bundle: .module)
}

#Preview {
    ZStack {
        Color.studioGrayFillProgress
        BodyMassIndexView(index: 22.3) {}
            .padding(.horizontal, 16)
    }
}
