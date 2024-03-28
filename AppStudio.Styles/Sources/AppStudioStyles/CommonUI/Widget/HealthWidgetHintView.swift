//
//  HealthWidgetHintView.swift
//
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import SwiftUI
import AppStudioModels

public struct HealthWidgetHintView: View {

    public enum Position {
        case top
        case bottom
    }

    private let hint: HealthWidgetHint
    private let position: Position
    private let onHide: () -> Void
    private let onLearnMore: () -> Void

    public init(hint: HealthWidgetHint,
                position: Position,
                onHide: @escaping () -> Void,
                onLearnMore: @escaping () -> Void) {
        self.hint = hint
        self.position = position
        self.onHide = onHide
        self.onLearnMore = onLearnMore
    }

    public var body: some View {
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
            Button(action: onLearnMore) {
                HStack(spacing: .buttonSpacing) {
                    Text(String.learnMore)
                    Image.chevronRight
                }
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioBlackLight)
            }
        }
        .padding(.top, position == .top ? .topPadding : .bottomPaddin)
        .padding(.bottom, position == .top ? .bottomPaddin : .topPadding)
        .padding(.horizontal, .horizontalPadding)
        .background(
            ZStack {
                Color.studioGreyStrokeFill
                    .corners(position == .top ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight],
                             with: .cornerRadius)
                Color.studioGrayFillProgress
                    .corners(position == .top ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight],
                             with: .cornerRadius)
                    .padding(position == .top ? .top : .bottom, 1)
                    .padding(.horizontal, 1)
            }

        )
        .offset(y: position == .top ? .offset : -.offset)
    }
}

private extension String {
    static let learnMore = "HealthWidgetHint.learnMore".localized(bundle: .module)
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
    HealthWidgetHintView(hint: .bodyMass, position: .top) {} onLearnMore: {}
        .padding(.horizontal, 16)
}

