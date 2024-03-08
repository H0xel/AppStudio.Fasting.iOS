//
//  FastingWidgetState.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Foundation

public enum FastingWidgetState {
    case active(ActiveFastingWidgetState)
    case inactive(InActiveFastingWidgetState)
}

extension FastingWidgetState {
    static var mockActive: FastingWidgetState {
        .active(.mock)
    }

    static var mockInActive: FastingWidgetState {
        .inactive(.mock)
    }
}
