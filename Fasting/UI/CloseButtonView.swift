//
//  CloseButtonView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 10.04.2024.
//

import SwiftUI
import AppStudioUI

struct CloseButtonView: View {

    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image.xmarkUnfilled
                .font(.headline)
                .foregroundStyle(.white)
        }
        .aligned(.centerVerticaly)
        .padding(.leading, .leadingPadding)
        .frame(height: .height)
        .aligned(.left)
    }
}

private extension CGFloat {
    static let height: CGFloat = 44
    static let leadingPadding: CGFloat = 32
}

#Preview {
    CloseButtonView {}
}
