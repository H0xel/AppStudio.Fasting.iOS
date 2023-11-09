//  
//  SuccessOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import Foundation
import AppStudioUI

typealias SuccessOutputBlock = ViewOutput<SuccessOutput>

enum SuccessOutput {
    case submit(startDate: Date, endDate: Date)
}
