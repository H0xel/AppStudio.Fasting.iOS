//
//  W2WNeedHelpView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.08.2024.
//

import SwiftUI
import AppStudioStyles

struct W2WNeedHelpView: View {
    var body: some View {
        HStack(spacing: .spacing) {
            Text(.needHelp)
                .font(.poppins(.body))
            Image.questionCircle
                .font(.system(size: 16))
        }
        .foregroundStyle(Color.studioBlackLight)
    }
}

private extension LocalizedStringKey {
    static let needHelp: LocalizedStringKey = "W2W.needHelp"
}

private extension CGFloat {
    static let spacing: CGFloat = 10
}

#Preview {
    W2WNeedHelpView()
}
