//
//  LogButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import SwiftUI

struct LogButton: View {

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image.checkmark
                .font(.body)
                .foregroundStyle(.white)
                .frame(width: .imageHeight, height: .imageHeight)
                .background(.accent)
                .continiousCornerRadius(.cornerRadius)
        }
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 44
    static let imageHeight: CGFloat = 44
}

#Preview {
    LogButton {}
}
