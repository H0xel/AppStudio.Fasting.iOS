//
//  SceneDelegate.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import UIKit
import Dependencies

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @Dependency(\.quickActionTypeServiceService) private var quickActionTypeServiceService

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        quickActionTypeServiceService.set(.init(rawValue: shortcutItem.type))
        completionHandler(true)
    }
}

