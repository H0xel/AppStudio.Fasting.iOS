//
//  LogChipsView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.05.2024.
//

import SwiftUI

struct LogChipsView: View {
    @Binding var selected: LogType
    let onClose: () -> Void
    private let types: [LogType] = [.history, .quickAdd]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .spacing) {
                ForEach(types, id: \.self) { type in
                    LogChipsButton(type: type,
                                   isSelected: type == selected,
                                   onClose: onClose,
                                   onTap: { withAnimation { selected = type } })
                }
            }
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
}
