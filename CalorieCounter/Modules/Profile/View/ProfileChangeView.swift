//
//  ProfileChangeView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI

struct ProfileChangeView: View {

    let isSaveButtonEnabled: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Text(.description)
                .font(.poppins(.body))
                .foregroundStyle(Color.studioGreyText)
                .multilineTextAlignment(.center)

            AccentButton(title: .saveChanges, action: onSave)
                .disabled(!isSaveButtonEnabled)
                .padding(.vertical, .buttonVerticalPadding)
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension LocalizedStringKey {
    static let description: LocalizedStringKey = "ProfileScreen.changeInfoDescription"
    static let saveChanges: LocalizedStringKey = "ProfileScreen.saveChanges"
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 32
    static let buttonVerticalPadding: CGFloat = 16
}

#Preview {
    ProfileChangeView(isSaveButtonEnabled: true, onSave: {})
}
