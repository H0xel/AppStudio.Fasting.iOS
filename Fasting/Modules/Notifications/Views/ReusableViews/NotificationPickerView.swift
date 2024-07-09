//
//  NotificationPickerView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationPickerView<Item: CustomStringConvertible & Hashable>: View {
    @Binding var selection: Item
    @Binding var isCollapsedType: CollapsedType
    let title: LocalizedStringKey
    let selections: [Item]
    let isLocked: Bool
    let type: CollapsedType


    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text(title)
                    .foregroundStyle(isLocked ? Color.placeholderText : Color.studioBlackLight)
                Spacer()
                Text(selection.description)
                    .foregroundStyle(isLocked ? Color.placeholderText : Color.studioGreyText)
                    .onTapGesture {
                        guard !isLocked else { return }
                        if type == isCollapsedType {
                            isCollapsedType = .close
                            return
                        }

                        isCollapsedType = type
                    }
            }
            .font(.poppins(.body))
            .padding(.top, .topPadding)

            if isCollapsedType == type {
                Picker("", selection: $selection) {
                    ForEach(selections, id: \.self) {
                        Text($0.description)
                            .font(.poppins(.body))
                    }
                }
                .pickerStyle(.wheel)
            }
        }
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 16
}
