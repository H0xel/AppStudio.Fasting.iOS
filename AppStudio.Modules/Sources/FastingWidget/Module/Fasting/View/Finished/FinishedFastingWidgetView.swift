//
//  FinishedFastingWidgetView.swift
//
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI
import AppStudioStyles

struct FinishedFastingWidgetView: View {

    let state: FinishedFastingWidgetState
    let onLog: (String?) -> Void

    var body: some View {
        if let fastingId = state.fastingId {
            VStack(spacing: .spacing) {
                WidgetTitleView(title: .youFastedFor, icon: nil, onTap: {})
                FinishedFastingWidgetTimeView(state: state)
                WidgetActionButton(title: .update,
                                   isActive: false) {
                    onLog(fastingId)
                }
            }
            .modifier(WidgetModifier())
        } else {
            VStack(alignment: .leading, spacing: .spacing) {
                WidgetTitleView(title: .youFastedFor, icon: nil, onTap: {})
                Text(String.zeroHours)
                    .font(.poppins(.headerM))
                    .foregroundStyle(Color.studioBlackLight)

                WidgetActionButton(title: .logFast,
                                   isActive: false) {
                    onLog(nil)
                }
            }
            .modifier(WidgetModifier())
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
}

private extension String {
    static let youFastedFor = "FastingWidgetView.youFastedFor".localized(bundle: .module)
    static let zeroHours = "FastingWidgetView.zeroHours".localized(bundle: .module)
    static let logFast = "FastingWidgetView.logFast".localized(bundle: .module)
    static let update = "FastingWidgetView.update".localized(bundle: .module)
}

#Preview {
    VStack {
        FinishedFastingWidgetView(state: .mockEmpty, onLog: { _ in })
        FinishedFastingWidgetView(state: .mockFinished, onLog: { _ in })
    }
}
