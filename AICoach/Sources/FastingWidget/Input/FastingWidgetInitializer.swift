//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation

public class FastingWidgetInitializer {

    public init() {}

    public func initialize(fastingWidgetService: FastingWidgetService) {
        FastingWidgetServiceKey.liveValue = fastingWidgetService
    }
}
