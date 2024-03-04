//
//  AccentButton.swift
//  
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

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

    @Dependency(\.styles) private var styles

    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .font(styles.fonts.buttonText)
            .frame(height: .lineHeight)
            .foregroundStyle(.white)
            .padding(.vertical, .verticalPadding)
            .aligned(.centerHorizontaly)
            .background(isEnabled ? styles.colors.accent : styles.colors.coachGreyStrokeFill)
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

