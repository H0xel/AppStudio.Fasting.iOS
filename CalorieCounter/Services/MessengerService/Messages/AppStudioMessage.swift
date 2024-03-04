//
//  AppStudioMessage.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//

import Foundation

class AppStudioMessage: Hashable {
    public let sender: Any?

    init(sender: Any?) {
        self.sender = sender
    }

    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }

    // MARK: Equatable
    public static func == (lhs: AppStudioMessage, rhs: AppStudioMessage) -> Bool {
        return lhs === rhs
    }
}
