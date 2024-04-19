//
//  AccentButton.swift
//  
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioUI

public struct AccentButton: View {

    private let title: TitleType
    private let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    private var cornerRadius: CGFloat

    public init(title: TitleType, cornerRadius: CGFloat = 22, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Button(action: action) {
            switch title {
            case .localizedString(let localizedStringKey):
                Text(localizedStringKey)
                    .accentButtonStyle(isEnabled: isEnabled, cornerRadius: cornerRadius)
            case .string(let string):
                Text(string)
                    .accentButtonStyle(isEnabled: isEnabled, cornerRadius: cornerRadius)
            }
        }
    }
}

private struct AccentButtonModifier: ViewModifier {

    var isEnabled: Bool
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.poppins(.buttonText))
            .frame(height: .lineHeight)
            .foregroundStyle(.white)
            .padding(.vertical, .verticalPadding)
            .aligned(.centerHorizontaly)
            .background(isEnabled ? Color.studioBlackLight : .studioGreyStrokeFill)
            .continiousCornerRadius(cornerRadius)
    }
}

extension View {
    func accentButtonStyle(isEnabled: Bool, cornerRadius: CGFloat = 22) -> some View {
        modifier(AccentButtonModifier(isEnabled: isEnabled, cornerRadius: cornerRadius))
    }
}

public extension AccentButton {
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


