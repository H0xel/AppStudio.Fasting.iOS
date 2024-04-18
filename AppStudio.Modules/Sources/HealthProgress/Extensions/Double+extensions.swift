//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import Foundation

extension Double {
    var bodyMassIndex: BodyMassIndex {
        if self < 18 {
            return .underweight
        }
        if self < 25 {
            return .normal
        }
        if self < 30 {
            return .overweight
        }
        return .obese
    }
}
