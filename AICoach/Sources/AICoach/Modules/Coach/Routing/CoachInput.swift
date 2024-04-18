//  
//  CoachInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//
import Combine

public struct CoachInput {

    let constants: CoachConstants
    let suggestionTypes: [CoachSuggestionType]
    let nextMessagePublisher: AnyPublisher<String, Never>
    let isMonetizationExpAvailable: AnyPublisher<Bool, Never>

    public init(constants: CoachConstants,
                suggestionTypes: [CoachSuggestionType],
                nextMessagePublisher: AnyPublisher<String, Never>,
                isMonetizationExpAvailable: AnyPublisher<Bool, Never>) {
        self.constants = constants
        self.nextMessagePublisher = nextMessagePublisher
        self.suggestionTypes = suggestionTypes
        self.isMonetizationExpAvailable = isMonetizationExpAvailable
    }
}
