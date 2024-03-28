//
//  HealthWidgetHint.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation

public struct HealthWidgetHint {
    public let title: String
    public let description: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

public extension HealthWidgetHint {
    static var bodyMass: HealthWidgetHint {
        .init(title: "HealthWidgetHint.bodyMass.title".localized(bundle: .module),
              description: "HealthWidgetHint.bodyMass.description".localized(bundle: .module))
    }

    static var weight: HealthWidgetHint {
        .init(title: "HealthWidgetHint.weight.title".localized(bundle: .module),
              description: "HealthWidgetHint.weight.description".localized(bundle: .module))
    }
}

