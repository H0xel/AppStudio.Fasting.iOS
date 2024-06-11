//
//  LogChipsView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.05.2024.
//

import SwiftUI

struct LogChipsView: View {
    let logType: LogType
    let onPick: (LogType) -> Void
    let onClose: () -> Void
    private let types: [LogType] = [.history, .quickAdd]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .spacing) {
                ForEach(types, id: \.self) { type in
                    LogChipsButton(type: type,
                                   isSelected: type == logType,
                                   onClose: onClose,
                                   onTap: { onPick(type) })
                }
            }
        }
        .padding(.top, .chipsTopPadding)
        .padding(.bottom, .bottomPadding)
        .padding(.horizontal, .horizontalChipsPadding)
        .transition(.identity)
        .padding(.top, -.chipsTopPadding)
        .background(.white)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
    static let chipsTopPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 10
    static let horizontalChipsPadding: CGFloat = 10
}
