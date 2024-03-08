//
//  UIScreen+extensions.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import UIKit

extension UIScreen {
    static var isSmallDevice: Bool {
        UIScreen.main.bounds.height <= 667
    }
}
