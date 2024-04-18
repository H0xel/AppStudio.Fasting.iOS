//  
//  CoachInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//
import Combine

public struct CoachInput {

    let constants: CoachConstants
    let nextMessagePublisher: AnyPublisher<String, Never>
    let isMonetizationExpAvailable: AnyPublisher<Bool, Never>

    public init(constants: CoachConstants,
                nextMessagePublisher: AnyPublisher<String, Never>,
                isMonetizationExpAvailable: AnyPublisher<Bool, Never>) {
        self.constants = constants
        self.nextMessagePublisher = nextMessagePublisher
        self.isMonetizationExpAvailable = isMonetizationExpAvailable
    }
}
