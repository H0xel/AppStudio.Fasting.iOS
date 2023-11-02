//  
//  StartFastingOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import Foundation
import AppStudioUI

typealias StartFastingOutputBlock = ViewOutput<StartFastingOutput>

enum StartFastingOutput {
    case save(Date)
}
