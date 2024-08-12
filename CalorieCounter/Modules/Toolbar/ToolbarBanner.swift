//
//  ToolbarBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.07.2024.
//

import SwiftUI
import AppStudioNavigation

struct ToolbarBanner: Banner {

    let items: [ToolbarAction]
    let onTap: (ToolbarAction) -> Void

    var view: AnyView {
        ToolbarView(items: items, onTap: onTap)
            .aligned(.bottom)
            .transition(.identity)
            .eraseToAnyView()
    }
}
