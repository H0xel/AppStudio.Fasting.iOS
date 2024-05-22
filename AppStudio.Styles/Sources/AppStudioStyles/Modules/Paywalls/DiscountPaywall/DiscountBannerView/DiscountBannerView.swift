//
//  DiscountBannerView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import SwiftUI

public struct DiscountBannerView: View {
    let viewData: ViewData
    let action: (Action) -> Void

    public init(viewData: ViewData, action: @escaping (Action) -> Void) {
        self.viewData = viewData
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {

            switch viewData.type {
            case .timer:
                DiscountTimerBannerView(timerInterval: viewData.timerInterval, discount: viewData.discount)
            case .promotion:
                DiscountPromotionBannerView(discount: viewData.discount) {
                    action(.close)
                }
                .padding(.trailing, .trailingPadding)
            }

            HStack(spacing: .zero) {
                Text(Localization.button(percent: viewData.discount))
                    .font(.poppins(.description))
                    .padding(.horizontal, .buttonHorizontalPadding)
                    .padding(.vertical, .buttonVerticalPadding)
                    .foregroundStyle(.white)
                    .background(.black)
                    .continiousCornerRadius(.buttonCornerRadius)
                    .padding(.bottom, .buttonBottomPadding)

                Spacer()

                Image(.discountBanner)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: .imageHeight)
            }
            .padding(.trailing, .trailingPadding)
        }
        .padding(.leading, .leadingPadding)
        .background()
        .continiousCornerRadius(.cornerRadius)
        .onTapGesture { action(.openPaywall) }
    }
}

private extension CGFloat {
    static var buttonHorizontalPadding: CGFloat { 32 }
    static var buttonVerticalPadding: CGFloat { 16 }
    static var buttonCornerRadius: CGFloat { 44 }
    static var buttonBottomPadding: CGFloat { 20 }
    static var imageHeight: CGFloat { 72 }
    static var leadingPadding: CGFloat { 24 }
    static var trailingPadding: CGFloat { 20 }
    static var cornerRadius: CGFloat { 20 }
}

extension DiscountBannerView {
    public struct ViewData {
        let discount: String
        let timerInterval: TimeInterval
        let type: BannerType

        public init(discount: String, timerInterval: TimeInterval, type: BannerType) {
            self.discount = discount
            self.timerInterval = timerInterval
            self.type = type
        }
    }

    public enum BannerType {
        case timer
        case promotion
    }

    public enum Action {
        case close
        case openPaywall
    }
}

extension DiscountBannerView.ViewData {
    public static var mock: DiscountBannerView.ViewData {
        .init(discount: "50%", timerInterval: .init(minutes: 15), type: .timer)
    }
}

private enum Localization {
    static func button(percent: String) -> String {
        let string = "DiscountPaywall.banner.button".localized(bundle: .module)
        return String(format: string, percent)
    }
}

#Preview {
    DiscountBannerView(viewData: .mock) { _ in }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}
