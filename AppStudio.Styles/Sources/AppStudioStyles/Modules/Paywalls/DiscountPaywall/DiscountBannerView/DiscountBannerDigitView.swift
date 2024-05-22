//
//  DiscountBannerDigitView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import SwiftUI

struct DiscountBannerDigitView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                Text(viewData.digit)
                    .font(.poppins(.headerS))
                    .aligned(.centerHorizontaly)
            }
            .padding(.vertical, .verticalPadding)
            .frame(width: .digitWidth)
            .background(Color.studioGrayFillCard)
            .continiousCornerRadius(.cornerRadius)
            .overlay {
                Rectangle()
                    .frame(height: .lineWidth)
                    .foregroundStyle(Color.studioGreyStrokeFill)
            }
            .border(configuration: .init(cornerRadius: .cornerRadius,
                                         color: .studioGreyStrokeFill,
                                         lineWidth: .lineWidth))

            Text(viewData.type.localizedString)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGrayText)
                .padding(.top, .topPadding)
        }
    }
}

extension DiscountBannerDigitView {
    struct ViewData {
        let digit: String
        let type: TimerType
    }

    enum TimerType: String {
        case days
        case hour = "hr"
        case min
        case sec

        var localizedString: String {
            NSLocalizedString("DiscountPaywall.\(rawValue)", comment: "")
        }
    }
}

private extension CGFloat {
    static var verticalPadding: CGFloat { 11 }
    static var digitWidth: CGFloat { 48 }
    static var cornerRadius: CGFloat { 12 }
    static var lineWidth: CGFloat { 0.5 }
    static var topPadding: CGFloat { 4 }
}


#Preview {
    HStack(spacing: 8) {
        DiscountBannerDigitView(viewData: .init(digit: "12", type: .days))
        DiscountBannerDigitView(viewData: .init(digit: "12", type: .hour))
        DiscountBannerDigitView(viewData: .init(digit: "12", type: .min))
        DiscountBannerDigitView(viewData: .init(digit: "12", type: .sec))
    }
}
