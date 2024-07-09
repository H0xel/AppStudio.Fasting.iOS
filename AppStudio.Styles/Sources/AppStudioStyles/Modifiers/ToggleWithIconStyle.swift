//
//  ToggleWithIconStyle.swift
//
//
//  Created by Amakhin Ivan on 13.06.2024.
//

import SwiftUI

public struct ToggleWithIconStyle: ToggleStyle {
    let systemImage: String
    let notificationAccessIsGranted: Bool
    let isLocked: Bool
    let activeColor: Color
    let action: (Action) -> Void

    public init(systemImage: String, 
                notificationAccessIsGranted: Bool,
                isLocked: Bool,
                activeColor: Color = .green,
                action: @escaping (Action) -> Void
    ) {
        self.systemImage = systemImage
        self.notificationAccessIsGranted = notificationAccessIsGranted
        self.isLocked = isLocked
        self.activeColor = activeColor
        self.action = action
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: .cornerRadius)
                .fill(configuration.isOn ? activeColor : Color(.systemGray5))
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(.padding)
                        .overlay {
                            if isLocked {
                                Image(systemName: systemImage)
                                    .foregroundColor(Color.studioBlackLight)
                                    .frame(width: .imageWidth, height: .imageHeight)
                            }
                        }
                        .offset(x: configuration.isOn ? .offset : -.offset)

                }
                .frame(width: .width, height: .height)
                .onTapGesture {
                    withAnimation(.spring()) {

                        if !notificationAccessIsGranted {
                            action(.notificationsAccessNotGranted)
                            return
                        }

                        if isLocked {
                            action(.isLocked)
                            return
                        }

                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

public extension ToggleWithIconStyle {
    enum Action {
        case isLocked
        case notificationsAccessNotGranted
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 30
    static let imageWidth: CGFloat = 11
    static let imageHeight: CGFloat = 9
    static let offset: CGFloat = 10
    static let width: CGFloat = 50
    static let height: CGFloat = 32
    static let padding: CGFloat = 3
}
