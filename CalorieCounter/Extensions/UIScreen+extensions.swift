//
//  UIScreen+extensions.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import UIKit

extension UIScreen {
    static var isSmallDevice: Bool {
        UIScreen.main.bounds.height <= 667
    }
}
