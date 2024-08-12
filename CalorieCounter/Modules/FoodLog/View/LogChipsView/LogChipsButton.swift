//
//  LogChipsButton.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.05.2024.
//

import SwiftUI

struct LogChipsButton: View {
    let type: LogType
    let isSelected: Bool
    let onClose: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            Button {
                onTap()
            } label: {
                HStack(spacing: .horizontalSpacing) {
                    if let image = type.image {
                        image
                            .renderingMode(isSelected ? .template : .original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .iconSize, height: .iconSize)
                            .foregroundStyle(isSelected ? Color.white : .clear)
                            .padding(.leading, .leadingPaddingWithIcon)
                    }

                    Text(type.title)
                        .font(font)
                        .padding(.leading, type.image != nil ? 0 : .leadingPaddingWithoutIcon)
                        .padding(.trailing, isSelected ? 0 : .trailingPaddingUnselected)

                    if isSelected {
                        Button {
                            onClose()
                        } label: {
                            Image.xmarkUnfilled
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .xmarkIconSize, height: .xmarkIconSize)
                                .padding(.xmarkIconPadding)
                                .opacity(CGFloat.xmarkIconOpacity)
                                .padding(.trailing, .trailingPaddingSelected)
                        }
                    }
                }
                .foregroundStyle(isSelected ? Color.white : Color.studioBlackLight)
                .padding(.vertical, .verticalPadding)
                .background(isSelected ? type.selectedColor : .white)
                .continiousCornerRadius(.cornerRadius)
                .border(
                    configuration: isSelected
                    ? .empty
                    : .init(cornerRadius: .cornerRadius, color: .separator, lineWidth: .borderLineWidth)
                )
                .contentShape(Rectangle())
            }
        }
    }

    private var font: Font {
        isSelected ? .poppinsBold(.description) : .poppins(.description)
    }
}

private extension CGFloat {
    static let iconSize: CGFloat = 16
    static let xmarkIconSize: CGFloat = 9.5
    static let xmarkIconPadding: CGFloat = 3.25
    static let xmarkIconOpacity: CGFloat = 0.6
    static let horizontalSpacing: CGFloat = 8
    static let leadingPaddingWithIcon: CGFloat = 12
    static let leadingPaddingWithoutIcon: CGFloat = 16
    static let trailingPaddingSelected: CGFloat = 10
    static let trailingPaddingUnselected: CGFloat = 16
    static let cornerRadius: CGFloat = 100
    static let verticalPadding: CGFloat = 8
    static let trailingPadding: CGFloat = 4
    static let borderLineWidth: CGFloat = 0.5
    static let separatorLength: CGFloat = 32
}
