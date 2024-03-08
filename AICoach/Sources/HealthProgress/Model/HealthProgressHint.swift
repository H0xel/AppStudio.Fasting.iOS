//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
//

import Foundation

public struct HealthProgressHint {
    let title: String
    let description: String
    let onLearnMore: () -> Void
}

public extension HealthProgressHint {
    static func bodyMass(onLearnMore: @escaping () -> Void) -> HealthProgressHint {
        .init(title: "HealthProgressHint.bodyMass.title".localized(bundle: .module),
              description: "HealthProgressHint.bodyMass.description".localized(bundle: .module),
              onLearnMore: onLearnMore)
    }
}
