//
//  Sex.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI

public enum Sex: String, CaseIterable, Identifiable, Codable {
    case male
    case female
    case other

    public var id: String {
        rawValue
    }

    public var title: String {
        NSLocalizedString("Sex.\(rawValue)", comment: "")
    }

    public var paywallTitle: String {
        switch self {
        case .male:
            "Sex.men".localized(bundle: .module)
        case .female, .other:
            "Sex.women".localized(bundle: .module)
        }
    }
}
