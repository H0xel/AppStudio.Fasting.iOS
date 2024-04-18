//
//  FastingWidgetInput.swift
//  
//
//  Created by Руслан Сафаргалеев on 12.03.2024.
//

import Foundation
import Combine

public struct FastingWidgetInput {

    let fastingStatePublisher: AnyPublisher<FastingWidgetState, Never>

    public init(fastingStatePublisher: AnyPublisher<FastingWidgetState, Never>) {
        self.fastingStatePublisher = fastingStatePublisher
    }
}
