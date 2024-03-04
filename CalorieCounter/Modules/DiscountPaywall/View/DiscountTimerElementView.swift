//
//  DiscountTimerElementView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI

struct DiscountTimerElementView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                Text(viewData.digit)
                    .font(.poppins(.headerL))
                    .foregroundStyle(.white)
                    .aligned(.centerHorizontaly)
            }
            .padding(.vertical, .verticalPadding)
            .frame(width: .width)
            .background(Color.studioRed)
            .continiousCornerRadius(.cornerRadius)

            .overlay {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(height: .dividerHeight)
            }

            Text(viewData.type.localizedString)
                .padding(.top, .topPadding)
        }
    }
}

extension DiscountTimerElementView {
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
            NSLocalizedString( "DiscountPaywall.\(self.rawValue)", comment: "")
        }
    }
}

extension DiscountTimerElementView.ViewData {
    static var mock: DiscountTimerElementView.ViewData {
        .init(digit: "00", type: .hour)
    }
}

private extension LocalizedStringKey {
    static var days: LocalizedStringKey { "DiscountPaywall.days" }
    static var hour: LocalizedStringKey { "DiscountPaywall.hr" }
    static var min: LocalizedStringKey { "DiscountPaywall.min" }
    static var sec: LocalizedStringKey { "DiscountPaywall.sec" }
}

private extension CGFloat {
    static var verticalPadding: CGFloat { 22 }
    static var horizontalPadding: CGFloat { 11 }
    static var cornerRadius: CGFloat { 12 }
    static var dividerHeight: CGFloat { 2 }
    static var topPadding: CGFloat { 8 }
    static var width: CGFloat { 64 }
}


#Preview {
    DiscountTimerElementView(viewData: .mock)
}
