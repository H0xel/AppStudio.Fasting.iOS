//
//  FastingProgressView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

struct FastingProgressView: View {

    let status: FastingStatus
    let plan: FastingPlan
    let hasSubscription: Bool
    let onTapStage: (FastingStage) -> Void
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                FastingRingView(status: status, plan: plan,
                                hasSubscription: hasSubscription,
                                onTapStage: onTapStage)
                    .padding(.horizontal, Layout.horizontalPadding)
                FastingProgressLabelView(status: status)
                    .foregroundColor(.label)
            }
            .foregroundColor(foregroundColor)
            Text(plan.description)
                .foregroundStyle(.accent)
                .frame(height: Layout.planTextHeight)
                .font(.poppins(.description))
                .padding(.vertical, Layout.planVerticalPadding)
                .padding(.horizontal, Layout.planHorizontalPadding)
                .background(.white)
                .continiousCornerRadius(Layout.planCornerRadius)
                .border(configuration: .init(cornerRadius: Layout.planCornerRadius,
                                             color: .studioGreyStrokeFill,
                                             lineWidth: Layout.planBorderWidth))
                .offset(y: Layout.planOffset)
                .onTapGesture {
                    action()
                }
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .active(let state):
            return state.stage.backgroundColor
        case .inActive:
            return .studioGrayFillProgress
        case .unknown:
            return .studioGrayFillProgress
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .active:
            return .white
        case .inActive:
            return .accent
        case .unknown:
            return .accent
        }
    }
}

private extension FastingProgressView {
    enum Layout {
        static let horizontalPadding: CGFloat = 15
        static let planVerticalPadding: CGFloat = 12
        static let planHorizontalPadding: CGFloat = 20
        static let planCornerRadius: CGFloat = 44
        static let planBorderWidth: CGFloat = 0.5
        static let planTextHeight: CGFloat = 20
        static let planOffset: CGFloat = 22
    }
}

#Preview {
    FastingProgressView(
        status: .active(.init(interval: .hour * 6.01, stage: .autophagy, isFinished: false)),
        plan: .regular,
        hasSubscription: true,
        onTapStage: { _ in },
        action: {}
    )
}
