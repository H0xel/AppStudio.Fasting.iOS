//
//  ActiveFastingWidgetView.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioStyles

struct ActiveFastingWidgetView: View {

    let state: ActiveFastingWidgetState

    var body: some View {
        VStack(spacing: .spacing) {
            WidgetTitleView(title: .youFastedFor,
                            icon: .widgetSettings,
                            onTap: state.onSettingsTap)
            ActiveFastingWidgetTimeView(state: state)
            ActiveFastingWidgetProgressView(state: state)
            WidgetActionButton(title: .endFasting,
                               isActive: state.finishDate <= .now,
                               onTap: state.onEndFastingTap)
        }
        .modifier(WidgetModifier())
    }
}

private extension String {
    static let youFastedFor = "FastingWidgetView.youFastedFor".localized(bundle: .module)
    static let endFasting = "FastingWidgetView.endFasting".localized(bundle: .module)
}

private extension CGFloat {
    static let spacing: CGFloat = 16
}

#Preview {
    ZStack {
        Color.red
        ActiveFastingWidgetView(state: .mock)
    }
}
