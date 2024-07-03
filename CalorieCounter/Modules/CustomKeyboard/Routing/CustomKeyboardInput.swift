//  
//  CustomKeyboardInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import Combine

struct CustomKeyboardInput {
    let title: String
    let text: String
    let style: CustomKeyboardStyle
    let servings: [MealServing]
    let currentServing: MealServing
    let isPresentedPublisher: AnyPublisher<Bool, Never>
}
