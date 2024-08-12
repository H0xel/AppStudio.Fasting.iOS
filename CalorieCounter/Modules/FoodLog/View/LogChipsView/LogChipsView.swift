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
    private let types: [LogType] = [.history, .food, .quickAdd, .newFood]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .spacing) {
                Spacer(minLength: .horizontalChipsPadding)
                ForEach(types, id: \.self) { type in
                    LogChipsButton(type: type,
                                   isSelected: type == logType,
                                   onClose: onClose,
                                   onTap: { onPick(type) })
                    if type.hasSeparator {
                        Rectangle()
                            .stroke(lineWidth: .borderLineWidth / 2)
                            .foregroundStyle(Color.separator)
                            .frame(width: .borderLineWidth, height: .separatorLength)
                    }
                }
                Spacer(minLength: .horizontalChipsPadding)
            }
        }
        .padding(.top, .chipsTopPadding)
        .padding(.bottom, .bottomPadding)
        .transition(.identity)
        .padding(.top, -.chipsTopPadding)
        .background(.white)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let chipsTopPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 10
    static let horizontalChipsPadding: CGFloat = 10
    static let borderLineWidth: CGFloat = 0.5
    static let separatorLength: CGFloat = 32
}
