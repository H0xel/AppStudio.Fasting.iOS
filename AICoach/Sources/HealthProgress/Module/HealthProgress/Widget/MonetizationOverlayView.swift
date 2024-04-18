//
//  MonetizationOverlayView.swift
//
//
//  Created by Amakhin Ivan on 12.04.2024.
//

import SwiftUI
import AppStudioStyles

struct MonetizationOverlayView: View {
    let input: HealthWidgetInput
    let action: () -> Void

    var body: some View {
        input.monetizationImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(content: {
                VStack {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundStyle(Color.studioRed)
                        .padding(.top, .topPadding)

                    Spacer()

                    Text(input.monetizationTitle)
                        .font(.poppinsBold(.body))

                    Spacer()

                    Text("Widget.getPlus".localized(bundle: .module))
                        .font(.poppins(.description))
                        .foregroundStyle(.white)
                        .padding(.vertical, .buttonVerticalPadding)
                        .padding(.horizontal, .buttonHorizontalPadding)
                        .background(Color.studioBlackLight)
                        .continiousCornerRadius(.buttonCornerRadius)
                        .padding(.bottom, .bottomPadding)
                        .onTapGesture {
                            action()
                        }
                }
            })
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 34
    static let buttonCornerRadius: CGFloat = 44
    static let buttonHorizontalPadding: CGFloat = 24
    static let buttonVerticalPadding: CGFloat = 14
}

#Preview {
    MonetizationOverlayView(input: .fasting) {}
}
