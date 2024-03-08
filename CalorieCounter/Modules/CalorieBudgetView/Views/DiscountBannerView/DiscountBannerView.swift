//
//  DiscountBannerView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import SwiftUI

struct DiscountBannerView: View {
    let viewData: ViewData
    let action: (Action) -> Void

    var body: some View {
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
                Text("DiscountPaywall.banner.button \(viewData.discount)")
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
    struct ViewData {
        let discount: String
        let timerInterval: TimeInterval
        let type: BannerType
    }

    enum BannerType {
        case timer
        case promotion
    }

    enum Action {
        case close
        case openPaywall
    }
}

extension DiscountBannerView.ViewData {
    static var mock: DiscountBannerView.ViewData {
        .init(discount: "50%", timerInterval: .init(minutes: 15), type: .timer)
    }
}

extension DiscountBannerView.ViewData? {
    init(hasSubscription: Bool, discountPaywallInfo: DiscountPaywallInfo?, timerInterval: TimeInterval) {
        guard let discountPaywallInfo, !hasSubscription else {
            self = nil
            return
        }

        var bannerData: DiscountBannerView.ViewData {
            .init(discount: "\(discountPaywallInfo.discount ?? 0)%",
                  timerInterval: timerInterval,
                  type: discountPaywallInfo.paywallType == "discount_timer" ? .timer : .promotion
            )
        }

        self = bannerData
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
