//
//  QuickAddSaveButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 04.06.2024.
//

import SwiftUI

struct QuickAddSaveButton: View {

    let isAvailable: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            Image.arrowUp
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .arrowImageSize, height: .arrowImageSize)
                .foregroundStyle(isAvailable
                                 ? Color.white
                                 : Color.studioGrayPlaceholder)
                .padding(.arrowImagePadding)
                .background(isAvailable
                            ? Color.studioBlackLight
                            : Color.studioGrayFillProgress)
                .continiousCornerRadius(.cornerRadius)
        }
        .disabled(!isAvailable)
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 100
    static let arrowImageSize: CGFloat = 14
    static let arrowImagePadding: CGFloat = 17
}

#Preview {
    QuickAddSaveButton(isAvailable: true, onTap: {})
}
