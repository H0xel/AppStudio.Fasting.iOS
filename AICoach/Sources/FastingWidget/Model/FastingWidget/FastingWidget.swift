//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation
import AppStudioUI

public struct FastingWidget {
    public let input: FastingWidgetInput
    public let output: ViewOutput<FastingWidgetOutput>

    public init(input: FastingWidgetInput, output: @escaping ViewOutput<FastingWidgetOutput>) {
        self.input = input
        self.output = output
    }
}
