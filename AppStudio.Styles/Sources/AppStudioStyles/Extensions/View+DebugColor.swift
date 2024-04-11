//
//  DebugColor.swift
//
//
//  Created by Amakhin Ivan on 29.03.2024.
//

import SwiftUI

public extension View {
#if DEBUG
    func debugColor() -> some View {
        self.background([Color.purple, Color.blue, Color.green, Color.yellow, Color.orange, Color.red].randomElement()!)
    }
#endif
}
