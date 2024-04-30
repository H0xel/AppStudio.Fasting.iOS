//
//  File.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Foundation
import AppStudioAnalytics

public enum DeepLink: String {
    case discount
}

extension DeepLink: TrackerParam {
    public var description: String {
        rawValue
    }
}
