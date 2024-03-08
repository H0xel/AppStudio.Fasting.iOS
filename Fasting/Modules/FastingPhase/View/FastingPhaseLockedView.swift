//
//  FastingPhaseLockedView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.12.2023.
//

import SwiftUI
import AppStudioUI

struct FastingPhaseLockedView: View {

    let stage: FastingStage
    let image: Image
    let onStageTap: (FastingStage) -> Void
    let onPaywallTap: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                FastingPhaseImageView(currentStage: stage,
                                      isLocked: true,
                                      onTap: onStageTap)
                    .aligned(.centerHorizontaly)
                    .padding(.vertical, Layout.imageVerticalPadding)
                    .background(backgroundColor)
                FastingPhaseTitleView(title: Localization.title(for: stage),
                                      backgroundColor: backgroundColor,
                                      image: image,
                                      isLocked: true)
                .overlay(overlay)
            }
            LockedViewPaywallButton(onTap: onPaywallTap)
                .padding(.horizontal, Layout.horizontalPadding)
        }
    }

    private var closeButton: some View {
        Image.close
            .foregroundStyle(.white)
            .fontWeight(.semibold)
    }

    private var overlay: some View {
        LinearGradient(colors: [.white.opacity(0), .white],
                       startPoint: .top,
                       endPoint: .bottom)
    }

    private var backgroundColor: Color {
        stage.backgroundColor
    }
}

private extension FastingPhaseLockedView {
    enum Localization {
        static func title(for stage: FastingStage) -> String {
            NSLocalizedString("FastingPhase.\(stage.rawValue).locked", comment: "")
        }
    }

    enum Layout {
        static let horizontalPadding: CGFloat = 40
        static let imageVerticalPadding: CGFloat = 16
    }
}

#Preview {
    NavigationStack {
        FastingPhaseLockedView(stage: .sugarRises,
                               image: .init(.sugarDownArticle),
                               onStageTap: { _ in },
                               onPaywallTap: {})
    }
}
