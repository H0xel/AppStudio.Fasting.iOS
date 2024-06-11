//
//  FoodHistoryInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.06.2024.
//

import Foundation
import Combine

struct FoodHistoryInput {
    let mealType: MealType
    let dayDate: Date
    let suggestionsState: SuggestionsState
    let hasSubscription: Bool
    let presentScannerPublusher: AnyPublisher<Void, Never>
    let mealPublisher: AnyPublisher<[MealItem], Never>
}
