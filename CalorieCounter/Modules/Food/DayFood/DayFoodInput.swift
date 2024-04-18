//
//  DayFoodInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 16.04.2024.
//

import Foundation
import Combine

struct DayFoodInput {
    let date: Date
    let router: FoodRouter
    let focusTextFieldPublisher: AnyPublisher<(Date, FoodLogContext), Never>
    let foodLogPublisher: AnyPublisher<(Date, MealType), Never>
    let updateProfilePublisher: AnyPublisher<Void, Never>
}
