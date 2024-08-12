//
//  ToolbarItem.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.07.2024.
//

import SwiftUI

enum ToolbarAction: String {
    case edit
    case copyAndCreateNew
    case remove
    case close

    var title: String {
        "Toolbar.\(rawValue)".localized()
    }

    var image: Image {
        switch self {
        case .edit: .bannerEdit
        case .copyAndCreateNew: .init(.toolbarCopy)
        case .remove: .bannerTrash
        case .close: .xmark
        }
    }
}
