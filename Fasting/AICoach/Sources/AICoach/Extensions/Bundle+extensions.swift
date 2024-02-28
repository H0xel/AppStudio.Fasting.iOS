//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 19.02.2024.
//

import Foundation

class CoachBundle: Bundle {}

extension Bundle {
    static let coachBundle: Bundle = {
      #if SWIFT_PACKAGE
      return Bundle.module
      #else
      return Bundle(for: CoachBundle.self)
      #endif
    }()
}
