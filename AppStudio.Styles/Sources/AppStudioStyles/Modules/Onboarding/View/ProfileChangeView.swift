//
//  ProfileChangeView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI

struct ProfileChangeView: View {

    let showDescription: Bool
    let isSaveButtonEnabled: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            if showDescription {
                Text(String.description)
                    .font(.poppins(.body))
                    .foregroundStyle(Color.studioGreyText)
                    .multilineTextAlignment(.center)
            }

            AccentButton(title: .string(.saveChanges), action: onSave)
                .disabled(!isSaveButtonEnabled)
                .padding(.vertical, .buttonVerticalPadding)
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension String {
    static let description = "ProfileScreen.changeInfoDescription".localized(bundle: .module)
    static let saveChanges = "ProfileScreen.saveChanges".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 32
    static let buttonVerticalPadding: CGFloat = 16
}

#Preview {
    ProfileChangeView(showDescription: true, isSaveButtonEnabled: true, onSave: {})
}
