//
//  StartFastingButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioUI

struct AccentButton: View {

    let title: TitleType
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            switch title {
            case .localizedString(let localizedStringKey):
                Text(localizedStringKey)
                    .accentButtonStyle(isEnabled: isEnabled)
            case .string(let string):
                Text(string)
                    .accentButtonStyle(isEnabled: isEnabled)
            }
        }
    }
}

private struct AccentButtonModifier: ViewModifier {
    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .font(.poppins(.buttonText))
            .frame(height: .lineHeight)
            .foregroundStyle(.white)
            .padding(.vertical, .verticalPadding)
            .aligned(.centerHorizontaly)
            .background(isEnabled ? Color.studioBlackLight : Color.studioGreyStrokeFill)
            .continiousCornerRadius(.cornerRadius)
    }
}

extension View {
    func accentButtonStyle(isEnabled: Bool) -> some View {
        modifier(AccentButtonModifier(isEnabled: isEnabled))
    }
}

extension AccentButton {
    enum TitleType {
        case localizedString(LocalizedStringKey)
        case string(String)
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 22
    static let verticalPadding: CGFloat = 18
    static let lineHeight: CGFloat = 27
}

#Preview {
    AccentButton(title: .localizedString("FastingScreen.startFasting"), action: {})
}
