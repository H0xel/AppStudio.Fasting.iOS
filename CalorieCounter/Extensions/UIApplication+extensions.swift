//
//  UIApplication+extensions.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import UIKit

extension UIApplication {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
