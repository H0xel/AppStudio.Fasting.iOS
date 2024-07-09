//
//  NotificationDatePickerView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationDatePickerView: View {
    @Binding var selection: Date
    @Binding var isCollapsedType: CollapsedType
    let title: LocalizedStringKey
    let type: CollapsedType
    let isLocked: Bool


    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text(title)
                    .foregroundStyle(isLocked ? Color.placeholderText : Color.studioBlackLight)
                Spacer()
                Text(selection.formatted(.dateTime.hour().minute()))
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
            .padding(.horizontal, .horizontalPadding)

            if isCollapsedType == type {
                DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .clipped()
                    .scaleEffect(.init(width: 0.9, height: 0.9))
            }
        }
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
}
