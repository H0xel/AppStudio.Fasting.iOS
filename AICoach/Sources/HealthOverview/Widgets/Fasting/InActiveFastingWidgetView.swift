//
//  InActiveFastingWidgetView.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioStyles

struct InActiveFastingWidgetView: View {

    let state: InActiveFastingWidgetState

    var body: some View {
        VStack(spacing: .spacing) {
            WidgetTitleView(title: state.title,
                            onTap: state.onSettingsTap)
            Text(state.subtitle)
                .font(.poppins(.headerM))
                .foregroundStyle(Color.studioBlackLight)

            WidgetActionButton(title: .startFasting,
                               isActive: true,
                               onTap: state.onButtonTap)
        }
        .modifier(WidgetModifier())
    }
}

private extension String {
    static let startFasting = "FastingWidgetView.startFasting".localized(bundle: .module)
}

private extension CGFloat {
    static let spacing: CGFloat = 16
}

#Preview {
    ZStack {
        Color.red
        InActiveFastingWidgetView(state: .mock)
    }
}
